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
        // In UI tests it is usually best to stop immediately when a failure occurs.
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation
        // for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        try super.tearDownWithError()
    }
    func testBadScriptGoodManifest(){
        let good = app.images["Selected"]
        app.launchArguments = ["badScript"]
        app.launch()
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        XCTAssertTrue(runButton.isEnabled)
        XCTAssertTrue(good.exists)
        runButton.tap()
        let bad = app.images["X Circle"]
        XCTAssertTrue(bad.exists)
        
    }
    
    func testGoodManifestGoodScript(){
        app.launchArguments = ["good"]
        app.launch()
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        let good = app.images["Selected"]
        XCTAssertTrue(runButton.isEnabled)
        XCTAssertTrue(good.exists)
        runButton.tap()
        let count = app.images.matching(identifier: "Selected")
        XCTAssertTrue(count.count==2)
        let outputButton = app.buttons["Open Output Files"]
        outputButton.tap()
        let file = app.staticTexts["/Users/student/Documents/ex1.txt"]
        XCTAssertTrue(file.exists)
    }
    
    func testInput(){
        app.launchArguments = ["input"]
        app.launch()
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        loadFileButton.tap()
        let testing = app.staticTexts["testing"]
        XCTAssertTrue(testing.exists)
    }
    
    func testBadManifest(){
        app.launchArguments = ["bad"]
        app.launch()
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        let bad = app.images["X Circle"]
        let badText = app.staticTexts["Error: The operation couldn’t be completed. (Lee.ManifestParseError error 1.)"]
        XCTAssertFalse(runButton.isEnabled)
        XCTAssertTrue(bad.exists)
        XCTAssertTrue(badText.exists)
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

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
