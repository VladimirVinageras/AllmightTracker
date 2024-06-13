//
//  TrackerCoreData+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vinakheras on 13.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var color: String?
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var schedule: TrackerScheduleCoreData?

}

extension TrackerCoreData : Identifiable {

}
