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
        continueAfterFailure = false
    }
    func testGoodOutput() async {
        let expectation = XCTestExpectation(description: "Check the good manifest")
        // Running the test
        // Finding the manifest_good.json file
        if let filepath = bundle.url(forResource: "manifest_good", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectation], timeout: 1.0)
        
        for currentOutput in ldm.getOutputs() {
            // Getting the output from the script
            let output = currentOutput.value
            // Test that the beginning of the output is initializing rune
            XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
            // Test that the next lines are related to the output of the program
            XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "num"))
            // Since good.py is using seed 10 for random, the output is expected to be 0.5714025946899135
            XCTAssertEqual(output[2], "0.5714025946899135")
            XCTAssertTrue(Rune.isValidRuneEnd(command: output[3]))
        }
    }
    func testInputOutput() async {
        let expectation = XCTestExpectation(description: "Check the input manifest")
        // Running the test
        // Finding the manifest_input.json file
        if let filepath = bundle.url(forResource: "manifest_input", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectation], timeout: 1.0)
        for currentOutput in ldm.getOutputs() {
            // Getting the output from the script
            let output = currentOutput.value
            // Test that the beginning of the output is initializing rune
            XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
            // Test that the next lines are related to the output of the program
            XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "num"))
            // Testing the input, which will be 'testing'
            XCTAssertEqual(output[2], "testing")
            // Testing that the final line is rune end
            XCTAssertTrue(Rune.isValidRuneEnd(command: output[3]))
        }
    }
    func testBadOutput() async {
        let expectation = XCTestExpectation(description: "Check the bad manifest")
        // Running the test
        // Finding the manifest_bad.json file
        if let filepath = bundle.url(forResource: "manifest_bad", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectation], timeout: 1.0)
        for currentOutput in ldm.getOutputs() {
            // Getting the output from the script
            let output = currentOutput.value
            // Test that the first line is rune initialization
            XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
            XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "error"))
            // Ensure that rune errors can be caught
            XCTAssertTrue(Rune.isValidRuneError(command: output[2]))
            // Ensure that the final line is rune closure
            XCTAssertTrue(Rune.isValidRuneEnd(command: output[3]))
        }
    }
    func testManyOutputs() async {
        let expectation = XCTestExpectation(description: "Check the multiple file manifest")
        // Running the test
        // Finding the manifest_many.json file
        if let filepath = bundle.url(forResource: "manifest_many", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectation], timeout: 1.0)
        for currentOutput in ldm.getOutputs() {
            // Getting the output from the script
            let output = currentOutput.value
            // Testing that the beginning is rune initialization
            XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
            // Testing the output for file one
            XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "ex1"))
            // The python script outputs the first 100 values
            for currentNum in 0...99 {
                XCTAssertEqual(output[currentNum + 2], String(currentNum))
            }
            // Testing the output for file two
            XCTAssertTrue(Rune.isValidRuneFile(command: output[102], fileName: "ex2"))
            // Verifying the output of the other program
            XCTAssertEqual(output[103], "3")
            XCTAssertEqual(output[104], "4")
            XCTAssertEqual(output[105], "More Testing")
            // Verifying the termination of the python script
            XCTAssertTrue(Rune.isValidRuneEnd(command: output[106]))
        }
    }
    func testMultipleScripts() async {
        
        let expectations = [XCTestExpectation(description: ""), XCTestExpectation(description: "")]
        var index = 0
        // Running the test
        // Finding the manifest_many.json file
        if let filepath = bundle.url(forResource: "manifest_multiple_scripts", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectations[index].fulfill()
                        index += 1
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch {
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectations[0], expectations[1]], timeout: 3.0)
        let outputs = ldm.getOutputs()
        for currentOutput in outputs {
            // Getting the output from the script
            let output = currentOutput.value
            if currentOutput.key.contains("good.py") {
                // Test that the beginning of the output is initializing rune
                XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
                // Test that the next lines are related to the output of the program
                XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "num"))
                // Since good.py is using seed 10 for random, the output is expected to be 0.5714025946899135
                XCTAssertEqual(output[2], "0.5714025946899135")
                XCTAssertTrue(Rune.isValidRuneEnd(command: output[3]))
            } else {
                // Testing that the beginning is rune initialization
                XCTAssertTrue(Rune.isValidRuneStart(command: output[0]))
                // Testing the output for file one
                XCTAssertTrue(Rune.isValidRuneFile(command: output[1], fileName: "ex1"))
                // The python script outputs the first 100 values
                for currentNum in 0...99 {
                    XCTAssertEqual(output[currentNum + 2], String(currentNum))
                }
                // Testing the output for file two
                XCTAssertTrue(Rune.isValidRuneFile(command: output[102], fileName: "ex2"))
                // Verifying the output of the other program
                XCTAssertEqual(output[103], "3")
                XCTAssertEqual(output[104], "4")
                XCTAssertEqual(output[105], "More Testing")
                // Verifying the termination of the python script
                XCTAssertTrue(Rune.isValidRuneEnd(command: output[106]))
            }
        }
    }
    func testMissingFile() async {
        let expectation = XCTestExpectation(description: "Check the no file manifest")
        // Finding the no_file.json file
        if let filepath = bundle.url(forResource: "no_file", withExtension: "json") {
            do {
                // Parse the data from the manifest file
                let parseResult = ldm.changeTargetManifest(url: filepath)
                // if parsing works, attempt to run the file
                if parseResult == .good {
                    // Set up the script runner from the manifest file
                    try await ldm.runScripts {
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Parsing the manifest went wrong")
                }
            } catch let error as ScriptError {
                // The only valid way for this test case to succeed
                XCTAssertTrue(ScriptError.missingFile == error)
                return
            } catch {
                // The manifest isn't appearing for the test to find
                print(error)
                XCTFail("Couldn't read in the manifest")
            }
        } else {
            XCTFail("Can't find manifest")
        }
        wait(for: [expectation], timeout: 3.0)
        XCTFail("Didn't have an error")
        
        
        
    }
}
