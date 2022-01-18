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

// MARK: Manage Apps
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
        
    private func convertFromDBEntityToApp(fetchedObjects: [AppEntity]) -> [AppElement] {
        var apps: [AppElement] = []
        for object in fetchedObjects {
            let app = AppElement(appid: Int(object.id), name: object.name ?? "", isFavorite: false)
            apps.append(app)
        }
        return apps
    }
    
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

// MARK: Manage AppNews
extension CoreDataManager {
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
    
//    private func convertFromNewsEntityToAppNews(fetchedObjects: [AppNewsEntity]) -> [Newsitem] {
//        var news: [Newsitem] = []
//        for object in fetchedObjects {
//            let oneNews = Newsitem(gid: object.gid, title: object.title, author: object.author, contents: object.contents, date: Int(object.date), appid: Int(object.appId))
//            news.append(oneNews)
//        }
//        return news
//    }
    
    private func convertFromDBEntityToNews(fetchedObjects: [AppNewsEntity]) -> [Newsitem] {
        var news: [Newsitem] = []
        for object in fetchedObjects {
            let newsItem = Newsitem(gid: object.gid, title: object.title, author: object.author, contents: object.contents, date: Int(object.date), appid: Int(object.appId))
            news.append(newsItem)
        }
        return news
    }
}

// MARK: Manage AppDetails
extension CoreDataManager {
    func fetchAppDetails(appId: Int, completion: @escaping (Result<AppDetails?, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<AppDetailsEntity> = AppDetailsEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
            let appDetailsEntity = fetchedObjects.first { appDetailsEntity in
                appDetailsEntity.appId == appId
            }
            if appDetailsEntity != nil {
                let appDetails = convertFromDBEntityToAppDetails(object: appDetailsEntity!)
                completion(.success(appDetails))
            } else {
                return
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveAppDetails(_ appDetails: AppDetails, completion: @escaping (Result<Bool, Error>) -> Void) {
        let detailsEntity = AppDetailsEntity(context: managedContext)
        detailsEntity.price = appDetails.priceOverview?.finalFormatted ?? ""
        detailsEntity.releaseDate = appDetails.releaseDate?.date ?? ""
        detailsEntity.headerImage = appDetails.headerImage ?? ""
        detailsEntity.shortdescription = appDetails.shortDescription
        detailsEntity.isFree = appDetails.isFree ?? false
        detailsEntity.linux = appDetails.platforms?.linux ?? false
        detailsEntity.mac = appDetails.platforms?.mac ?? false
        detailsEntity.windows = appDetails.platforms?.windows ?? false
        detailsEntity.discount = Int32(appDetails.priceOverview?.discountPercent ?? 0)
        detailsEntity.appId = Int32(appDetails.steamAppid ?? 0)
        detailsEntity.name = appDetails.name
        detailsEntity.genre = appDetails.genres?.compactMap({ $0.genreDescription })
        detailsEntity.screenshots = appDetails.screenshots?.compactMap({ $0.pathFull })
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteAppDetails(appId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppDetailsEntity")
        deleteFetch.predicate = NSPredicate(format: "appId == %d", appId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func convertFromDBEntityToAppDetails(object: AppDetailsEntity) -> AppDetails? {
        let platforms = Platforms(windows: object.windows, mac: object.mac, linux: object.linux)
        var genres: [Genre] = []
        object.genre?.forEach({ genreDescription in
            genres.append(Genre(genreDescription: genreDescription))
        })
        var screenshots: [Screenshot] = []
        object.screenshots?.forEach({ fullPath in
            screenshots.append(Screenshot(pathFull: fullPath))
        })
        let detailsItem = AppDetails(name: object.name, steamAppid: Int(object.appId), isFree: object.isFree, shortDescription: object.shortdescription, headerImage: object.headerImage, priceOverview: PriceOverview(currency: "", initial: 0, priceOverviewFinal: 0, discountPercent: Int(object.discount), initialFormatted: "", finalFormatted: object.price), platforms: platforms, genres: genres, screenshots: screenshots, releaseDate: ReleaseDate(date: object.releaseDate))
        return detailsItem
    }
}

// MARK: Manage Favorites
extension CoreDataManager {
    func updateFavoriteApp(app: AppElement, appDetails: AppDetails) {
        var newApp = app
        newApp.appDetails = appDetails
        removeAppFromFavorites(app: app)
        addAppToFavorites(app: newApp)
    }
    func addAppToFavorites(app: AppElement) {
        let context = managedContext
        let newFavoriteEntity = FavoriteEntity(context: context)
        newFavoriteEntity.id = Int32(app.appid)
        newFavoriteEntity.name = app.name
        
        /// create price string:
        var price: String
        var priceRawValue: Float
        
        if let isFree = app.appDetails?.isFree, isFree {
            price = "Free"
            priceRawValue = 0
        } else {
            price = app.appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "USD ")) ?? "-"
            
            let priceString = app.appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "$USD ")) ?? "0"
            
            priceRawValue = Float(priceString) ?? 0
        }
        var haveDiscount: Bool = false
        if let discount = app.appDetails?.priceOverview?.discountPercent, discount != 0 {
            price += " (-\(discount)%)"
            haveDiscount = true
        }
        newFavoriteEntity.price = price
        newFavoriteEntity.priceRawValue = priceRawValue
        newFavoriteEntity.haveDiscount = haveDiscount
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
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
        } catch {
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
        } catch {
            print(error)
        }
        return []
    }
    
    private func convertFromFavoriteEntityToApp(fetchedObjects: [FavoriteEntity]) -> [AppElement] {
        var apps: [AppElement] = []
        for object in fetchedObjects {
            let app = AppElement(appid: Int(object.id), name: object.name ?? "", isFavorite: true, price: object.price, priceRawValue: object.priceRawValue, haveDiscount: object.haveDiscount)
            apps.append(app)
        }
        return apps
    }
}
