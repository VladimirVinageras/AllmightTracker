//
//  TrackerCategoryStore.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 04.06.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    //MARK: - VARIABLES
    private var context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
    private let trackerStore = TrackerStore()
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0)})
        else { return [] }
        return categories
    }
    
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
    
    func fetchTrackerCategories() throws -> [TrackerCategory]{
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let categoriesFromCoreData = try context.fetch(fetchRequest)
        return try categoriesFromCoreData.map{try self.trackerCategory(from: $0)}
    }
    
    func saveNewTracker(with newTracker: Tracker, to categoryTitle: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let existingCategories = try context.fetch(fetchRequest)
        
        if let existingCategory = existingCategories.first {
            var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
            
            let trackerStore = TrackerStore(context: context)
            let newTrackerCoreData = try trackerStore.addNewTracker(newTracker)
            
            existingTrackers.append(newTrackerCoreData)
            existingCategory.trackers = NSSet(array: existingTrackers)
        } else {
            let newCategoryCoreData = TrackerCategoryCoreData(context: context)
            newCategoryCoreData.title = categoryTitle
            
            let trackerStore = TrackerStore(context: context)
            let newTrackerCoreData = try trackerStore.addNewTracker(newTracker)
            
            newCategoryCoreData.trackers = NSSet(array: [newTrackerCoreData])
        }
        try context.save()
    }
    
  func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
    let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "title == %@", trackerCategory.title)
    let results = try context.fetch(fetchRequest)
    
    if let existingCategory = results.first {
        try updateExistingTrackerCategory(existingCategory, with: trackerCategory)
    } else {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        try updateExistingTrackerCategory(trackerCategoryCoreData, with: trackerCategory)
    }
    
    try context.save()
}

    
    func updateExistingTrackerCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with trackerCategory: TrackerCategory) throws {
        trackerCategoryCoreData.title = trackerCategory.title
        
        let trackers = trackerCategory.trackers
        
        var trackersCoreData = [TrackerCoreData]()
        for tracker in trackers {
            let trackerStore = TrackerStore(context: context)
            let newTrackerCoreData = try trackerStore.addNewTracker(tracker)
            trackersCoreData.append(newTrackerCoreData)
        }
        
        trackerCategoryCoreData.trackers =  NSSet(array: trackersCoreData)
        
        try context.save()
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title
              else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
         }
        
        let trackerCategoryCoreDataSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData>
        let trackers = try trackerCategoryCoreDataSet?.compactMap {
            try TrackerStore(context: context).tracker(from: $0)
        }
        guard let trackers = trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        
        return TrackerCategory(title: title, trackers: trackers)
     }
}

//MARK: - ADDING FUNCTIONS
extension TrackerCategoryStore {
    func saveTrackerToCategory(tracker: Tracker, in categoryTitle: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        let results = try context.fetch(fetchRequest)
        
        if let existingCategory = results.first {
            var existingTrackers = existingCategory.trackers as? Set<TrackerCoreData> ?? Set<TrackerCoreData>()
            
            let trackerStore = TrackerStore(context: context)
            let newTrackerCoreData = try trackerStore.addNewTracker(tracker)
            
            existingTrackers.insert(newTrackerCoreData)
            existingCategory.trackers = NSSet(set: existingTrackers)
            
            try context.save()
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            try addNewTrackerCategory(newCategory)
        }
        
        try context.save()
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in 
            self?.delegate?.storeCategoryDidChange()
        }
    }
}

