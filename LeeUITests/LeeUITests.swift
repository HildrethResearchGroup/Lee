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
    //Tests a good manifest that has a bad script
    func testBadScriptGoodManifest(){
        //The green check
        let good = app.images["Selected"]
        //The red x
        let bad = app.images["X Circle"]
        //establish buttons that will be clicked
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        //let the app know what file to run
        app.launchArguments = ["badScript"]
        app.launch()
        //Run button should start disabled
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        //Once file button is enabled, run button should be enabled
        XCTAssertTrue(runButton.isEnabled)
        //Green check for manifest
        XCTAssertTrue(good.exists)
        runButton.tap()
        //red x for script
        XCTAssertTrue(bad.exists)
        
    }
    //Test a good manifest that runs a good script, here the manifest with multiple files
    func testGoodManifestGoodScript(){
        //Which file to load
        app.launchArguments = ["good"]
        //Buttons that will be clicked
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        let outputButton = app.buttons["Open Output Files"]
        //Green Check
        let good = app.images["Selected"]
        
        app.launch()
        //run button disabled until script loaded
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        XCTAssertTrue(runButton.isEnabled)
        //script status green
        XCTAssertTrue(good.exists)
        runButton.tap()
        //count the number of green checks
        let count = app.images.matching(identifier: "Selected")
        XCTAssertTrue(count.count==2)
        outputButton.tap()
        //Check that output got displayed
        let file = app.staticTexts["/Users/student/Documents/ex1.txt"]
        XCTAssertTrue(file.exists)
    }
    
    //checking input parameters window works
    func testInput(){
        //Establish buttons
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        //Text we are looking for
        let testing = app.staticTexts["testing"]
        //Which file to load
        app.launchArguments = ["input"]
        app.launch()
        loadFileButton.tap()
        //parameters window exists
        XCTAssertTrue(testing.exists)
    }
    
    //Test that a bad manifest works as expected
    func testBadManifest(){
        //which file to load
        app.launchArguments = ["bad"]
        //establish buttons
        let loadFileButton = app.buttons["Load File"]
        let runButton = app.buttons["Run"]
        //Red X
        let bad = app.images["X Circle"]
        //Text to look for
        let badText = app.staticTexts["Error: The operation couldn’t be completed. (Lee.ManifestParseError error 1.)"]
        app.launch()
        //run button should be disabled until good manifest loaded
        XCTAssertFalse(runButton.isEnabled)
        loadFileButton.tap()
        XCTAssertFalse(runButton.isEnabled)
        //Error text and red x should be displayed
        XCTAssertTrue(bad.exists)
        XCTAssertTrue(badText.exists)
    }
    
    //Test that the parameters window launches
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
