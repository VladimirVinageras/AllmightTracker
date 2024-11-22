//
//  TrackerCategoryStoreError.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 06.06.2024.
//

import Foundation

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTracker
    case decodingErrorInvalidFetch
}
