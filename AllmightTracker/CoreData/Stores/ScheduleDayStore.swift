//
//  ScheduleDayStore.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 06.06.2024.
//

import Foundation
import UIKit
import CoreData

final class ScheduleDayStore {
    private let context: NSManagedObjectContext
    
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
    
    func fetchScheduleDay() throws -> [ScheduleDay] {
        let fetchRequest = ScheduleDayCoreData.fetchRequest()
        let scheduleDaysFromCoreData = try context.fetch(fetchRequest)
        return try scheduleDaysFromCoreData.map { try self.scheduleDay(from: $0) }
    }
    
    func addNewSchedule(_ scheduleDay: ScheduleDay) throws -> ScheduleDayCoreData {
        let scheduleDayCoreData = ScheduleDayCoreData(context: context)
        updateExistingScheduleDay(scheduleDayCoreData, with: scheduleDay)
        try context.save()
        
        return scheduleDayCoreData
    }
    
    func updateExistingScheduleDay(_ scheduleDayCoreData: ScheduleDayCoreData, with scheduleDay: ScheduleDay) {
        scheduleDayCoreData.scheduledDay = Int64(scheduleDay.scheduleDay.rawValue)
        scheduleDayCoreData.isScheduled = scheduleDay.isScheduled
    }
    
    func scheduleDay(from scheduleDayCoreData: ScheduleDayCoreData) throws -> ScheduleDay {
        guard let scheduleDay = Weekday(rawValue: Int(scheduleDayCoreData.scheduledDay)) else {
            throw ScheduleDayStoreError.decodingErroInvalidScheduleDay
        }
        let isScheduled = scheduleDayCoreData.isScheduled
        return ScheduleDay(scheduleDay: scheduleDay, isScheduled: isScheduled
        )
    }
}
