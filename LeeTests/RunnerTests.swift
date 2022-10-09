//
//  RunnerTests.swift
//  LeeTests
//
//  Created by Mines Student on 10/1/22.
//

import XCTest
@testable import Lee

class RunnerTests: XCTestCase {
    let ldm = LeeDataModel()
    let bundle = Bundle(for: RunnerTests.self)
    override func setUp() {
    }
    func testGoodOutput() async {
        // Running the test
        // Finding the manifest_good.json file
        if let filepath = Bundle.main.path(forResource: "manifest_good", ofType: "json") {
            do {
                // Need the contents to be able to parse the string
                let contents = try String(contentsOfFile: filepath)
                // Set up the script runner from the manifest file
                try await ldm.runScript()
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Since good.py is using seed 10 for random, the output is expected to be 0.5714025946899135
        XCTAssertEqual(output[2], "0.5714025946899135")
    }
    func testInputOutput() async {
        // Finding the manifest_input.json file
        if let filepath = Bundle.main.path(forResource: "manifest_input", ofType: "json") {
            do {
                // Need the contents to be able to parse the string
                let contents = try String(contentsOfFile: filepath)
                // Set up the script runner from the manifest file
                try await ldm.runScript()
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Testing the input, which will be 'testing'
        XCTAssertEqual(output[2], "testing")
    }
    func testBadOutput() async {
        // Finding the manifest_bad.json file
        if let filepath = Bundle.main.path(forResource: "manifest_bad", ofType: "json") {
            do {
                // Need the contents to be able to parse the string
                let contents = try String(contentsOfFile: filepath)
                // Set up the script runner from the manifest file
                try await ldm.runScript()
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Handle the error of the program
    }
}
