//
//  AppNewsEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 27.12.21.
//
//

import Foundation
import CoreData


extension AppNewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppNewsEntity> {
        return NSFetchRequest<AppNewsEntity>(entityName: "AppNewsEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var contents: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var app: AppEntity?

}
