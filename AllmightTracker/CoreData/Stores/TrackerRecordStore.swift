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
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.idCompletedTracker , ascending: true)
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve the context from the AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTrackerRecords() throws -> [TrackerRecord]{
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
    }

    func addNewTrackerRecord(_ trackerID: UUID, completionDate: Date) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.idCompletedTracker = trackerID
        trackerRecordCoreData.datetTrackerCompleted = completionDate
        try context.save()
    }
    
    func deleteTrackerRecord (idCompletedTracker: UUID, completionDate: Date) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        var trackerRecordsCoreData = try context.fetch(fetchRequest)
        let trackerRecordCoreData = trackerRecordsCoreData.first { record in
            record.idCompletedTracker == idCompletedTracker &&
            record.datetTrackerCompleted == completionDate
        }
        guard let trackerRecordCoreData = trackerRecordCoreData else {return}
        context.delete(trackerRecordCoreData)
        trackerRecordsCoreData = try context.fetch(fetchRequest)
    }
    
    
    func countingTimesCompleted(idCompletedTracker: UUID) -> Int{
        var records : [TrackerRecord] = []
        do {
            records = try fetchTrackerRecords().filter {
                $0.idCompletedTracker == idCompletedTracker
            }
        }
            catch{
                print("Error fetching tracker record: \(TrackerStoreError.decodingErrorInvalidFetch)")
                return 0
            }
            return records.count
    }
    
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        
        guard let recordDate = trackerRecordCoreData.datetTrackerCompleted,
              let idCompletedTracker = trackerRecordCoreData.idCompletedTracker else {
            throw TrackerRecordStoreError.decodingErrorInvalidRecord
        }
        
    return TrackerRecord(idCompletedTracker: idCompletedTracker, dateTrackerCompleted: recordDate)
    }

}




