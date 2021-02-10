//
//  SquareEmployeeDirectoryUITests.swift
//  SquareEmployeeDirectoryUITests
//
//  Created by Angelina Wu on 30/01/2021.
//

import XCTest

class SquareEmployeeDirectoryUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenericHappyPath() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.tables.cells.count, 7)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Justine Mason"]/*[[".cells.staticTexts[\"Justine Mason\"]",".staticTexts[\"Justine Mason\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Justine Mason"].buttons["Employee List"].tap()
        XCUIDevice.shared.press(.home)
        app.activate()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Justine Mason"]/*[[".cells.staticTexts[\"Justine Mason\"]",".staticTexts[\"Justine Mason\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.terminate()
    }
}
