//
//  AppDetailsEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//
//

import Foundation
import CoreData


extension AppDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppDetailsEntity> {
        return NSFetchRequest<AppDetailsEntity>(entityName: "AppDetailsEntity")
    }

    @NSManaged public var discount: Int32
    @NSManaged public var headerImage: String?
    @NSManaged public var isFree: Bool
    @NSManaged public var linux: Bool
    @NSManaged public var mac: Bool
    @NSManaged public var price: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var shortdescription: String?
    @NSManaged public var windows: Bool
    @NSManaged public var appId: Int32
    @NSManaged public var name: String?
    @NSManaged public var screenshots: [String]?
    @NSManaged public var genre: [String]?
}
