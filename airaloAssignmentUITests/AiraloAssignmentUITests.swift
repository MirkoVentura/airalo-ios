//
//  AiraloAssignmentUITests.swift
//  airaloAssignment
//
//  Created by Mirko Ventura on 24/04/25.
//


import XCTest

final class AiraloAssignmentUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPopularCountriesListLoadsAndDisplays() {
        let app = XCUIApplication()
        app.launchArguments = ["-useMockService"]
        app.launch()

        let navigationTitle = app.navigationBars["Hello"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5))

        let header = app.staticTexts["Popular Countries"]
        XCTAssertTrue(header.exists)

        let italy = app.staticTexts["Italy"]
        let japan = app.staticTexts["Japan"]

        XCTAssertTrue(italy.waitForExistence(timeout: 5))
        XCTAssertTrue(japan.exists)

        italy.tap()
        let detailTitle = app.staticTexts["Italia"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5))
    }
}
