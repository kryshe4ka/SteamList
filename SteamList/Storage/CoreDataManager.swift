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
        return AppDetails(type: nil,
                          name: nil,
                          steamAppid: nil,
                          requiredAge: nil,
                          isFree: nil,
                          detailedDescription: nil,
                          aboutTheGame: nil,
                          shortDescription: nil,
                          supportedLanguages: nil,
                          headerImage: nil,
                          website: nil,
//                          pcRequirements: nil,
//                          macRequirements: nil,
//                          linuxRequirements: nil,
                          legalNotice: nil,
                          developers: nil,
                          publishers: nil,
                          priceOverview: nil,
                          packages: nil,
                          packageGroups: nil,
                          platforms: nil,
                          categories: nil,
                          genres: nil,
                          screenshots: nil,
                          movies: nil,
                          achievements: nil,
                          releaseDate: nil,
                          supportInfo: nil,
                          background: nil
//                          ,contentDescriptors: nil
        )
    }
    
    func fetchAppNews(appId: Int, count: Int) -> [AppNews] {
        return []
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
