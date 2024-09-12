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
    
    func testTrackersViewControllerDark() throws {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTrackersViewControllerLight() throws {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
}
