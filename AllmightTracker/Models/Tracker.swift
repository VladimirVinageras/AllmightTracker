//
//  Tracker.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 10.05.2024.
//

import Foundation
import UIKit

struct Tracker{
    let id: UUID
    let name: String
    let colorName: String
    let emoji: String
    let schedule: TrackerSchedule
    var isPinned: Bool
}
