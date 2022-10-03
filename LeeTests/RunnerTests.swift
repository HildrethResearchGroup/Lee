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
    override func setUp() {
    }
    func isValidStartOutput(output: [String]) {
        // This marks the start of the output read from the script
        XCTAssertEqual(output[0], "$@RUNE_START@$")
    }
    func isValidEndOutput(output: [String]) {
        // This marks the end of the output read from the script
        XCTAssertEqual(output.last, "$@RUNE_END@$")
    }
    func testGoodOutput() async {
        // Set up the script runner from the manifest file
        ldm.changeTargetManifest(path: "manifest_good.json")
        // Running the test
        do {
            try await ldm.runScript()
        } catch {
            print(error)
            XCTFail()
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Since good.py is using seed 10 for random, the output is expected to be 0.5714025946899135
        XCTAssertEqual(output[2], "0.5714025946899135")
    }
    func testInputOutput() async {
        // Set up the script runner from the manifest file
        ldm.changeTargetManifest(path: "../PythonFiles/manifest_input.json")
        // Running the test
        do {
            try await ldm.runScript()
        } catch {
            print(error)
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Testing the input, which will be 'testing'
        XCTAssertEqual(output[2], "testing")
    }
    func testBadOutput() async {
        // Set up the script runner from the manifest file
        ldm.changeTargetManifest(path: "../PythonFiles/manifest_bad.json")
        // Running the test
        do {
            try await ldm.runScript()
        } catch {
            print(error)
        }
        // Getting the output from the script
        let output = ldm.getOutput()
        // Test that the next lines are related to the output of the program
        XCTAssertEqual(output[1], "$@RUNE_OUTPUT(num)@$")
        // Handle the error of the program
    }
}
