//
//  TrackerCategoriesViewModel.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 17.06.2024.
//

final class TrackerCategoriesViewModel {
    private let trackerCategoryStore : TrackerCategoryStore
    
    private(set) var selectedCategory : TrackerCategory? =  nil{
        didSet{
            selectedCategoryBinding?(selectedCategory)
        }
    }
    
    private(set) var trackerCategories: [TrackerCategory] = []{
        didSet{
            categoriesBinding?(trackerCategories)
        }
    }
    
    var categoriesBinding : Binding<[TrackerCategory]>?
    var selectedCategoryBinding : Binding<TrackerCategory?>?
    
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategories = self.fetchCategories()
        
    }
    
    func fetchCategories() -> [TrackerCategory]{
        var categories : [TrackerCategory] = []
        do {
            categories =  try trackerCategoryStore.fetchTrackerCategories()
        }
        catch{
            print("Failed to fetch tracker categories: \(error.localizedDescription)")
        }
        
        return categories
    }
    
    func addCategory(category: TrackerCategory) {
        trackerCategories.append(category)
    }
    
    func didSelect(at indexPosition: Int ){
        selectedCategory = trackerCategories[indexPosition]
    }
    
}
