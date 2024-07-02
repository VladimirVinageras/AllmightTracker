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
    var name: String
    var colorName: String
    var emoji: String
    var schedule: TrackerSchedule
    var isPinned: Bool
}
