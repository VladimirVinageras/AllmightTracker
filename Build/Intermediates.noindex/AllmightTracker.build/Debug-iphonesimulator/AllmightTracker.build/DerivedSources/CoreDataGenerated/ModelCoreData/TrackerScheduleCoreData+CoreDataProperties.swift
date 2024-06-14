//
//  TrackerScheduleCoreData+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vinakheras on 14.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerScheduleCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerScheduleCoreData> {
        return NSFetchRequest<TrackerScheduleCoreData>(entityName: "TrackerScheduleCoreData")
    }

    @NSManaged public var dateEnd: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isAnHabit: Bool
    @NSManaged public var scheduledDays: NSSet?

}

// MARK: Generated accessors for scheduledDays
extension TrackerScheduleCoreData {

    @objc(addScheduledDaysObject:)
    @NSManaged public func addToScheduledDays(_ value: ScheduleDayCoreData)

    @objc(removeScheduledDaysObject:)
    @NSManaged public func removeFromScheduledDays(_ value: ScheduleDayCoreData)

    @objc(addScheduledDays:)
    @NSManaged public func addToScheduledDays(_ values: NSSet)

    @objc(removeScheduledDays:)
    @NSManaged public func removeFromScheduledDays(_ values: NSSet)

}

extension TrackerScheduleCoreData : Identifiable {

}
