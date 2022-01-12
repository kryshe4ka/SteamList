//
//  CoreDataManager.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let modelName = "SteamList"
    private var fetchedResultsController: NSFetchedResultsController<AppEntity>!
    
    
    /// Persistent Container
    private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: modelName)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    /// Get the managed Object Context
    private lazy var managedContext: NSManagedObjectContext = {
      return self.persistentContainer.viewContext
    }()
    
    init() {
        self.fetchedResultsController = {
            let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            return frc
        }()
    }
}

extension CoreDataManager: Storage {
    
    func fetchApps(completion: @escaping (Result<[AppElement], Error>) -> Void) {
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController?.fetchedObjects else { return }
            let apps = convertFromDBEntityToApp(fetchedObjects: fetchedObjects)
            completion(.success(apps))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchNews(completion: @escaping (Result<[Newsitem], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<AppNewsEntity> = AppNewsEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
            let news = convertFromDBEntityToNews(fetchedObjects: fetchedObjects)
            completion(.success(news))
        } catch {
            completion(.failure(error))
        }
    }
    private func convertFromDBEntityToNews(fetchedObjects: [AppNewsEntity]) -> [Newsitem] {
        var news: [Newsitem] = []
        for object in fetchedObjects {
            let newsItem = Newsitem(gid: object.gid, title: object.title, author: object.author, contents: object.contents, date: Int(object.date), appid: Int(object.appId))
            news.append(newsItem)
        }
        return news
    }
    
    private func convertFromDBEntityToApp(fetchedObjects: [AppEntity]) -> [AppElement] {
        var apps: [AppElement] = []
        for object in fetchedObjects {
            let app = AppElement(appid: Int(object.id), name: object.name ?? "", isFavorite: false)
            apps.append(app)
        }
        return apps
    }
    
    func fetchAppDetails(appId: Int) -> AppDetails {
        return AppDetails(
            name: nil,
            steamAppid: nil,
            isFree: nil,
            shortDescription: nil,
            headerImage: nil,
            priceOverview: nil,
            platforms: nil,
            genres: nil,
            screenshots: nil,
            releaseDate: nil
        )
    }

    func fetchAppNews(app: AppElement, count: Int, completion: @escaping (Result<[Newsitem], Error>) -> Void) {
         guard let appEntity = fetchedResultsController.fetchedObjects?.first(where: { appEntity in
            appEntity.id == Int32(app.appid)
        }) else {
            print("fetchAppNews error 1")
            return
        }
        guard let fetchedObjects = appEntity.news?.array as? [AppNewsEntity] else {
            print("fetchAppNews error 2")
            return
        }
        if fetchedObjects.isEmpty {
            print("empty")
        } else {
            let news = convertFromNewsEntityToAppNews(fetchedObjects: fetchedObjects)
            completion(.success(news))
        }
        
    }
    
    func saveNews(_ news: [Newsitem], completion: @escaping (Result<Bool, Error>) -> Void)  {
        /// get main context
        let mainQueueContext = managedContext
        /// get private context
        let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        /// make main context as a parent of child
        privateChildContext.parent = mainQueueContext
        privateChildContext.perform {
            for newsItem in news {
                let newsEntity = AppNewsEntity(context: privateChildContext)
                newsEntity.gid = newsItem.gid
                newsEntity.author = newsItem.author
                newsEntity.contents = newsItem.contents
                newsEntity.title = newsItem.title
                newsEntity.appId = Int32(newsItem.appid ?? 0)
                newsEntity.date = Int32(newsItem.date ?? 0)
            }
            /// merge changes to main context
            do {
                try privateChildContext.save()
            } catch {
                completion(.failure(error))
            }
            
            mainQueueContext.performAndWait {
                do {
                    try mainQueueContext.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteNews(completion: @escaping (Result<Bool, Error>) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppNewsEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addToNews(newsItem: Newsitem) {
        guard let appId = newsItem.appid else { return }
        guard let appEntity = fetchedResultsController.fetchedObjects?.first(where: { appEntity in
            appEntity.id == Int32(appId)
        }) else {
            print("fetchAppNews error 1")
            return
        }
        let newsEntity = AppNewsEntity(context: managedContext)
        newsEntity.gid = newsItem.gid
        newsEntity.author = newsItem.author
        newsEntity.contents = newsItem.contents
        newsEntity.title = newsItem.title
//        newsEntity.app = appEntity
        newsEntity.appId = Int32(newsItem.appid ?? 0)
        newsEntity.date = Int32(newsItem.date ?? 0)
        appEntity.addToNews(newsEntity)
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func convertFromNewsEntityToAppNews(fetchedObjects: [AppNewsEntity]) -> [Newsitem] {
        var news: [Newsitem] = []
        for object in fetchedObjects {
//            let appId = Int(object.app?.id ?? 0)
//            let oneNews = Newsitem(gid: object.id, title: object.title, author: object.author, contents: object.contents, date: Int(object.date), appid: appId)
            
            let oneNews = Newsitem(gid: object.gid, title: object.title, author: object.author, contents: object.contents, date: Int(object.date), appid: Int(object.appId))
            
            news.append(oneNews)
        }
        return news
    }
    
//    func saveApps2(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void){
//        let context = managedContext
//        for app in apps {
//            let newAppEntity = AppEntity(context: context)
//            newAppEntity.id = Int32(app.appid)
//            newAppEntity.name = app.name
//            newAppEntity.isFavorite = app.isFavorite ?? false
//            newAppEntity.price = app.price
//            newAppEntity.haveDiscount = app.haveDiscount ?? false
//        }
//        if context.hasChanges {
//            do {
//                try context.save()
//                completion(.success(true))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
    
    func deleteApps(completion: @escaping (Result<Bool, Error>) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveApps(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void) {
        // get main context
        let mainQueueContext = managedContext
        // get private context
        let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // make main context as a parent of child
        privateChildContext.parent = mainQueueContext
        privateChildContext.perform {
            for app in apps {
                let newAppEntity = AppEntity(context: privateChildContext)
                newAppEntity.id = Int32(app.appid)
                newAppEntity.name = app.name
                newAppEntity.isFavorite = app.isFavorite ?? false
                newAppEntity.price = app.price
                newAppEntity.haveDiscount = app.haveDiscount ?? false
            }
            // merge changes to main context
            do {
                try privateChildContext.save()
            } catch {
                completion(.failure(error))
            }
            
            mainQueueContext.performAndWait {
                do {
                    try mainQueueContext.save()
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

extension CoreDataManager {
    func addAppToFavorites(app: AppElement) {
        let context = managedContext
        let newFavoriteEntity = FavoriteEntity(context: context)
        newFavoriteEntity.id = Int32(app.appid)
        newFavoriteEntity.name = app.name
        
        /// create price string:
        var price: String
        if let isFree = app.appDetails?.isFree, isFree {
            price = "Free"
        } else {
            price = app.appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "USD ")) ?? "-"
        }
        var haveDiscount: Bool = false
        if let discount = app.appDetails?.priceOverview?.discountPercent, discount != 0 {
            price += " (-\(discount)%)"
            haveDiscount = true
        }
        newFavoriteEntity.price = price
        newFavoriteEntity.haveDiscount = haveDiscount
        
        if context.hasChanges {
            do {
                try context.save()
//                completion(.success(true))
            } catch {
//                completion(.failure(error))
                print(error)
            }
        }
    }
    
    func removeAppFromFavorites(app: AppElement) { //}(completion: @escaping (Result<Bool, Error>) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteEntity")
        deleteFetch.predicate = NSPredicate(format: "id == %d", app.appid)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
//            completion(.success(true))
        } catch {
//            completion(.failure(error))
            print(error)
        }
    }
    
    func fetchFavoriteApps(sortKey: String) -> [AppElement] { // }(completion: @escaping (Result<[FavoriteEntity], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return [] }
            let apps = convertFromFavoriteEntityToApp(fetchedObjects: fetchedObjects)
            return apps
//            completion(.success(fetchedObjects))
        } catch {
//            completion(.failure(error))
            print(error)
        }
        return []
    }
    
    private func convertFromFavoriteEntityToApp(fetchedObjects: [FavoriteEntity]) -> [AppElement] {
        var apps: [AppElement] = []
        for object in fetchedObjects {
            let app = AppElement(appid: Int(object.id), name: object.name ?? "", isFavorite: true, price: object.price, haveDiscount: object.haveDiscount)
            apps.append(app)
        }
        return apps
    }
}
