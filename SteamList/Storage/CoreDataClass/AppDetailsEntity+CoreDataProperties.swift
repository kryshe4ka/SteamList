//
//  AppDetailsEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 27.12.21.
//
//

import Foundation
import CoreData


extension AppDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppDetailsEntity> {
        return NSFetchRequest<AppDetailsEntity>(entityName: "AppDetailsEntity")
    }

    @NSManaged public var discount: Double
    @NSManaged public var headerImage: Data?
    @NSManaged public var isFree: Bool
    @NSManaged public var linux: Bool
    @NSManaged public var mac: Bool
    @NSManaged public var price: Double
    @NSManaged public var releaseDate: Date?
    @NSManaged public var shortdescription: String?
    @NSManaged public var windows: Bool
    @NSManaged public var app: AppEntity?

}
