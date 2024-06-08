//
//  TrackerSchedule.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 10.05.2024.
//

import Foundation
import UIKit

struct TrackerSchedule {
    let id: UUID
   // let dateStart: Date
   // let dateEnd: Date
    let isAnHabit: Bool
    let scheduledDays : [ScheduleDay]?
}
