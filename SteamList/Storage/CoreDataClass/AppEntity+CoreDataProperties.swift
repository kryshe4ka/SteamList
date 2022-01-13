//
//  AppEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
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
    @NSManaged public var haveDiscount: Bool
    @NSManaged public var price: String?
    @NSManaged public var news: NSOrderedSet?
//    @NSManaged public var details: AppDetailsEntity?
//    @NSManaged var newsArray: [Newsitem]?

}

// MARK: Generated accessors for news
extension AppEntity {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: AppNewsEntity)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: AppNewsEntity)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSOrderedSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSOrderedSet)

}
