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
    let modelName = "SteamList"
    
    var fetchedResultsController: NSFetchedResultsController<AppEntity>!

    
    /// Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: modelName)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    /// Get the managed Object Context
    lazy var managedContext: NSManagedObjectContext = {
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
    
    func convertFromDBEntityToApp(fetchedObjects: [AppEntity]) -> [AppElement] {
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
    
    func fetchAppNews(appId: Int, count: Int) -> [Newsitem] {
        return []
    }
    
    // Save the data in Database
    func saveApps(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void){
        
        let context = managedContext
        
        for app in apps {
            let newAppEntity = AppEntity(context: context)
            newAppEntity.id = Int32(app.appid)
            newAppEntity.name = app.name
            newAppEntity.isFavorite = app.isFavorite ?? false
        }
        
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                completion(.failure(error))
            }
        }
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
    
    
    func saveApps2(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void) {
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
            }
        }
        // merge changes to main context
        privateChildContext.perform {
            do {
                try privateChildContext.save()
            } catch {
                completion(.failure(error))
            }
        }
        
        do {
            try mainQueueContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
