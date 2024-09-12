//
//  Weekday.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 20.05.2024.
//

import Foundation
import UIKit

enum Weekday: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var name: String {
        switch self {
        case .monday:
            return dictionaryUI.weekDayMonday
        case .tuesday:
            return dictionaryUI.weekDayThuesday
        case .wednesday:
            return dictionaryUI.weekDayWednesday
        case .thursday:
            return dictionaryUI.weekDayThursday
        case .friday:
            return dictionaryUI.weekDayFriday
        case .saturday:
            return dictionaryUI.weekDaySaturday
        case .sunday:
            return dictionaryUI.weekDaySunday
        }
    }
    var shortDaysName: String {
        switch self {
        case .monday:
            return dictionaryUI.weekDayShortMonday
        case .tuesday:
            return dictionaryUI.weekDayShortThuesday
        case .wednesday:
            return dictionaryUI.weekDayShortWednesday
        case .thursday:
            return dictionaryUI.weekDayShortThursday
        case .friday:
            return dictionaryUI.weekDayShortFriday
        case .saturday:
            return dictionaryUI.weekDayShortSaturday
        case .sunday:
            return dictionaryUI.weekDayShortSunday
        }
    }
}


extension Weekday {
    init?(from date: Date) {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date)
        
        let adjustedIndex = (weekdayIndex == 1) ? 7 : (weekdayIndex - 1)
        
        self.init(rawValue: adjustedIndex)
    }
}
