//
//  TrackerScheduleStore.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 06.06.2024.
//

import Foundation
import UIKit
import CoreData


final class TrackerScheduleStore {
    
    //MARK: - VARIABLES
    private let context: NSManagedObjectContext
    
    //MARK: - FUNCTIONS
     
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve the context from the AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTrackerSchedules() throws -> [TrackerSchedule] {
        let fetchRequest = TrackerScheduleCoreData.fetchRequest()
        let trackerScheduleFromCoreData = try context.fetch(fetchRequest)
        return try trackerScheduleFromCoreData.map { try self.trackerSchedule(from: $0) }
    }

    func addNewTrackerSchedule(_ trackerSchedule: TrackerSchedule) throws -> TrackerScheduleCoreData{
        let trackerScheduleCoreData = TrackerScheduleCoreData(context: context)
        try updateExistingTrackerSchedule(trackerScheduleCoreData, with: trackerSchedule)
        try context.save()
        return trackerScheduleCoreData
    }

    func updateExistingTrackerSchedule(_ trackerScheduleCoreData: TrackerScheduleCoreData, with trackerSchedule: TrackerSchedule) throws {
        trackerScheduleCoreData.id = trackerSchedule.id
        trackerScheduleCoreData.dateStart = Date()
        trackerScheduleCoreData.dateEnd = Date()
        trackerScheduleCoreData.isAnHabit = trackerSchedule.isAnHabit
        
        guard let days = trackerSchedule.scheduledDays else {return}
        
        var scheduledDaysCoreData = [ScheduleDayCoreData]()
        for day in days {
            let newScheduledDayStore = ScheduleDayStore(context: context)
            let newScheduledDayCoreData = try newScheduledDayStore.addNewSchedule(day)
            scheduledDaysCoreData.append(newScheduledDayCoreData)
        }
        
        trackerScheduleCoreData.scheduledDays =  NSSet(array: scheduledDaysCoreData)
    }

    func trackerSchedule(from trackerScheduleCoreData: TrackerScheduleCoreData) throws -> TrackerSchedule {
        guard let id = trackerScheduleCoreData.id else {
            throw TrackerScheduleStoreError.decodingErroInvalidScheduledDays
        }
        
        let scheduledDaysCoreDataSet = trackerScheduleCoreData.scheduledDays as? Set<ScheduleDayCoreData>
        let scheduledDays = try scheduledDaysCoreDataSet?.compactMap {
            try ScheduleDayStore(context: context).scheduleDay(from: $0)
        }
        
        return TrackerSchedule(id: id, isAnHabit: trackerScheduleCoreData.isAnHabit, scheduledDays: scheduledDays)
    }


}
