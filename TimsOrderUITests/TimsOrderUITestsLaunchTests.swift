//
//  TimsOrderUITestsLaunchTests.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  Launch performance test — measures how long the app takes to start.
//

import XCTest

final class TimsOrderUITestsLaunchTests: XCTestCase {

    // Allow the launch test to continue even if individual assertions fail
    override class var runsForEachTargetApplicationUIConfiguration: Bool { true }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Test: Measure launch time
    // This records the app's startup time as a performance baseline.
    func testLaunch() throws {
        let app = XCUIApplication()

        // measure { } records the time taken — viewable in the Xcode Test Report
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
