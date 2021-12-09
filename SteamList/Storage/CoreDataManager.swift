//
//  CoreDataManager.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    let modelName = "SteamList"
    
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
}

extension CoreDataManager: Storage {
    func fetchApps() -> [App] {
        return []
    }
    
    func fetchAppDetails(appId: Int) -> AppDetails {
        return AppDetails()
    }
    
    func fetchAppNews(appId: Int, count: Int) -> [AppNews] {
        return []
    }
}
