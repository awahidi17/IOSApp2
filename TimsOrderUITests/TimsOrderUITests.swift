//
//  TimsOrderUITests.swift
//  TimsOrder — Foodies Cafe
//
//  Created by Ahmad Wahidi
//  Course: MWD3A — iOS Development
//  Assignment 2
//
//  UI tests for the TimsOrder app.
//  These tests launch the actual app and interact with the UI programmatically.
//

import XCTest

final class TimsOrderUITests: XCTestCase {

    // setUp() runs before every test method
    override func setUpWithError() throws {
        // Stop immediately when a failure occurs — don't keep running broken tests
        continueAfterFailure = false
    }

    // MARK: - Test: App launches successfully
    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        // The app should be in a running state after launch
        XCTAssertTrue(app.state == .runningForeground)
    }
}
