//
//  Liked+CoreDataProperties.swift
//  
//
//  Created by Assel Artykbay on 23.11.2024.
//
//

import Foundation
import CoreData


extension Liked {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liked> {
        return NSFetchRequest<Liked>(entityName: "Liked")
    }

    @NSManaged public var link: String?
    @NSManaged public var liked: Bool

}
