//
//  FilterListViewControllerProtocol.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 03.07.2024.
//

import Foundation


protocol FilterListViewControllerDelegate {
    func customFilterDidSelect(withFilter filter: Filters)
}
