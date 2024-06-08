//
//  TrackerStore.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 04.06.2024.
//

import Foundation
import UIKit
import CoreData

final class TrackerStore: NSObject{
    
    //MARK: - VARIABLES
    private var context: NSManagedObjectContext
    
    private let uiColorMarshalling = UIColorMarshalling()

    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
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
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    
    
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - FUNCTIONS
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        fetchedResultsController.delegate = self
    }
    


//    func fetchTrackers() throws -> [Tracker]{
//        let fetchRequest = TrackerCoreData.fetchRequest()
//        let trackersFromCoreData = try context.fetch(fetchRequest)
//        return try trackersFromCoreData.map{try self.tracker(from: $0)}
//    }
    
    func addNewTracker(_ tracker: Tracker) throws -> TrackerCoreData{
        let trackerCoreData = TrackerCoreData(context: context)
        try updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
        return trackerCoreData
    }
    
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) throws {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling().hexString(from: tracker.color)
        let schedule = tracker.schedule
        let trackerScheduleStore = TrackerScheduleStore(context: context)
        let newTrackerScheduleCoreData = try trackerScheduleStore.addNewTrackerSchedule(schedule)
        trackerCoreData.schedule = newTrackerScheduleCoreData
               
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
         guard let id = trackerCoreData.id,
               let emoji = trackerCoreData.emoji,
               let colorString = trackerCoreData.color,
               
               let name = trackerCoreData.name else {
             throw TrackerStoreError.decodingErrorInvalidFetch
         }
        let color = uiColorMarshalling.color(from: colorString)
    
         var schedule: TrackerSchedule? = nil
        if let scheduleCoreData = trackerCoreData.schedule {
            schedule = try trackerSchedule(from: scheduleCoreData)
        }
        guard let schedule = schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
     }
     
    private func trackerSchedule(from trackerScheduleCoreData: TrackerScheduleCoreData) throws -> TrackerSchedule {
        return try TrackerScheduleStore(context: context).trackerSchedule(from: trackerScheduleCoreData)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store()
    }
}

