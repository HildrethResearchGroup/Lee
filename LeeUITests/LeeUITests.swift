//
//  LeeUITests.swift
//  LeeUITests
//
//  Created by Mines Student on 8/30/22.
//

import XCTest
@testable import Lee

class LeeUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()

        // In UI tests it is usually best to stop immediately when a failure occurs.

        // In UI tests it’s important to set the initial state - such as interface orientation
        // for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        try super.tearDownWithError()
    }

    func testLoadFile() {
        // given
        app.launch()
        let loadFileButton = app.buttons["Load File"]
        let typeLabel = app.staticTexts["Current Manifest: "]
        let good = app.images["checkmark.circle.fill"]
        let file = app.dialogs["Choose a file"]
        let bad = app.images["multiply.circle.fill"]
        loadFileButton.tap()
        XCTAssertTrue(file.exists)
       
    }
    
    func testGoodManifest() {
        // given
        app.launchArguments = ["-goodManifest"]
        app.launch()
        let run = app.buttons["Run"]
        let typeLabel = app.staticTexts["Current Manifest: "]
        let good = app.images["checkmark.circle.fill"]
        let file = app.dialogs["Choose a file"]
        let bad = app.images["multiply.circle.fill"]
        XCTAssertTrue(good.exists)
        XCTAssertTrue(run.isEnabled)
       
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
