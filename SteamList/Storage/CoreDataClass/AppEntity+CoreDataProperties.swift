//
//  AppEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 27.12.21.
//
//

import Foundation
import CoreData


extension AppEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppEntity> {
        return NSFetchRequest<AppEntity>(entityName: "AppEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
//    @NSManaged public var appDetails: AppDetailsEntity?
//    @NSManaged public var news: [AppNewsEntity]?

}

// MARK: Generated accessors for news
extension AppEntity {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: AppNewsEntity)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: AppNewsEntity)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)

}
