//
//  TrackerStoreDelegate.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.06.2024.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func store() -> Void
}
