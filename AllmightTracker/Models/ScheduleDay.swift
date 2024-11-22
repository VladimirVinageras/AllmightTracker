//
//  ScheduleDay.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 27.05.2024.
//

import Foundation
import UIKit


struct ScheduleDay : Equatable{
    var scheduleDay: Weekday
    var isScheduled: Bool
    
    static func ==(lhs: ScheduleDay, rhs: ScheduleDay) -> Bool {
        return lhs.scheduleDay == rhs.scheduleDay
    }
}
