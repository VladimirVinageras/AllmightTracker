//
//  ScheduleViewControllerProtocol.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerProtocol{
    func updateEventSelectedDays(with newSelectedDays: String, and weekdays: [ScheduleDay]) 
    
    func checkingSelectedDays() -> [ScheduleDay]
  
}

protocol ScheduleCellProtocol{
    func updateDayStatus(to day: ScheduleDay, with newStatus: Bool)
}

protocol KeepingScheduleDaysProtocol
{
    
}


