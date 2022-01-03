//
//  AppNewsEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
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
    @NSManaged public var date: Int32
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var app: AppEntity?

}
