//
//  TrackerCategory.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 10.05.2024.
//

import Foundation
import UIKit

struct TrackerCategory: Equatable{
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let trackers: [Tracker]
}
