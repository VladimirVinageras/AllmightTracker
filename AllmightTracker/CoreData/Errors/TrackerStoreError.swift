//
//  TrackerStoreError.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 06.06.2024.
//

import Foundation

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidColor
    case decodingErrorInvalidSchedule
    case decodingErrorInvalidFetch
}
