//
//  TrackerRecordStore.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 04.06.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerRecordStore : NSObject {
    private let context: NSManagedObjectContext
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id , ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        return controller
    }()
    
    var trackerRecords: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try self.trackerRecord(from: $0)})
        else { return [] }
        return records
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTrackerRecord() throws -> [TrackerRecord]{
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
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
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        
        guard let recordDate = trackerRecordCoreData.datetTrackerCompleted,
              let idCompletedTracker = trackerRecordCoreData.idCompletedTracker else {
            throw TrackerRecordStoreError.decodingErrorInvalidRecord
        }
        
    return TrackerRecord(idCompletedTracker: idCompletedTracker, dateTrackerCompleted: recordDate)
    }

}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeRecord()
    }
}



