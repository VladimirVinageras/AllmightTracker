//
//  AllmightTrackerTests.swift
//  AllmightTrackerTests
//
//  Created by Vladimir Vinakheras on 03.07.2024.
//

import XCTest
import SnapshotTesting
@testable import AllmightTracker

final class AllmightTrackerTests: XCTestCase {

    func testTrackersViewController(){
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image)
    }
}
