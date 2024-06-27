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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve the context from the AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        fetchedResultsController.delegate = self
    }
    
    
    func addNewTracker(_ tracker: Tracker) throws -> TrackerCoreData{
        let trackerCoreData = TrackerCoreData(context: context)
        try updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
        return trackerCoreData
    }
    
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) throws {
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling().hexString(from: tracker.color)
        trackerCoreData.isPinned = tracker.isPinned
        let schedule = tracker.schedule
        let trackerScheduleStore = TrackerScheduleStore(context: context)
        let newTrackerScheduleCoreData = try trackerScheduleStore.addNewTrackerSchedule(schedule)
        trackerCoreData.schedule = newTrackerScheduleCoreData
    }

    func pinUnpinTracker(id: UUID, with isPinned: Bool) throws {
        guard let trackerToUpdate = fetchTracker(by: id) else {return}
        var trackerStore = try tracker(from: trackerToUpdate)
        trackerStore.isPinned = isPinned
        try updateExistingTracker(trackerToUpdate, with: trackerStore)
        try context.save()
    }
    
    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(fetchRequest) as [TrackerCoreData] else {
            return nil
        }
        
        return trackerCoreData.first
    }
    
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
         guard let id = trackerCoreData.trackerId,
               let emoji = trackerCoreData.emoji,
               let colorString = trackerCoreData.color,
               let name = trackerCoreData.name else {
             throw TrackerStoreError.decodingErrorInvalidFetch
         }
        let color = uiColorMarshalling.color(from: colorString)
        let isPinned = trackerCoreData.isPinned
    
         var schedule: TrackerSchedule? = nil
        if let scheduleCoreData = trackerCoreData.schedule {
            schedule = try trackerSchedule(from: scheduleCoreData)
        }
        guard let schedule = schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule, isPinned: isPinned)
     }
     
    private func trackerSchedule(from trackerScheduleCoreData: TrackerScheduleCoreData) throws -> TrackerSchedule {
        return try TrackerScheduleStore(context: context).trackerSchedule(from: trackerScheduleCoreData)
    }
    
    func deleteTracker(by id: UUID) throws {
        guard let trackerToDelete = fetchTracker(by: id) else {return}
        context.delete(trackerToDelete)
        try context.save()
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store()
    }
}

