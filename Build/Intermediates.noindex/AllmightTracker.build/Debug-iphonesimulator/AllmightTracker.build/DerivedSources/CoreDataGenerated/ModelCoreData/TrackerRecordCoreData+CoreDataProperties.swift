//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vinakheras on 11.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var datetTrackerCompleted: Date?
    @NSManaged public var idCompletedTracker: UUID?

}

extension TrackerRecordCoreData : Identifiable {

}
