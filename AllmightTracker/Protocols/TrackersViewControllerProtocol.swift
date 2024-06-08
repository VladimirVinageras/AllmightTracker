//
//  TrackersViewControllerProtocol.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit

protocol TrackersViewControllerProtocol{
    func saveNewTracker(with newCategoryName: String, for newEvent: Tracker)
}
