//
//  TrackerRecordStoreError.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 06.06.2024.
//

import Foundation


enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidFetch
    case decodingErrorInvalidRecord
}
