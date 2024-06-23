//
//  ScheduleDayCoreData+CoreDataProperties.swift
//  
//
//  Created by Vladimir Vinakheras on 22.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ScheduleDayCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleDayCoreData> {
        return NSFetchRequest<ScheduleDayCoreData>(entityName: "ScheduleDayCoreData")
    }

    @NSManaged public var isScheduled: Bool
    @NSManaged public var scheduledDay: Int64

}

extension ScheduleDayCoreData : Identifiable {

}
