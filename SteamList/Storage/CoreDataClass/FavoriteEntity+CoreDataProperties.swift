//
//  FavoriteEntity+CoreDataProperties.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var haveDiscount: Bool
}
