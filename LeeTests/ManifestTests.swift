//
//  ManifestTests.swift
//  LeeTests
//
//  Created by Mines Student on 9/15/22.
//
import XCTest
@testable import Lee

struct Manifests {
    static let pythonSimple: String = """
    {
        "program": {
            "runner": "python",
            "entry": "main.py"
        },
        "inputs": [
            {
                "name": "in-file",
                "type": "path",
            }
        ],
        "outputs": [
            {
                "name": "output1"
            }
        ]
    }
    """
    static let pythonCommented: String = """
    {
        "program": {
            "runner": "python",
            "entry": "main.py"
        },
        "inputs": [
            {
                "name": "inputImage",
                "type": "path",
                "comment": "The image to process"
            },
            {
                "name": "timeout",
                "type": "int",
                "comment": "Time in seconds to allow script to run"
            }
        ],
        "outputs": [
            {
                "name": "output1",
                "comment": "This is the first output"
            }
        ]
    }
    """
}

class ManifestTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }
    func testPythonSimple() throws {
        // Attempt to parse
        let manifest = try Manifest.fromString(source: Manifests.pythonSimple)
        // Check program section
        XCTAssertEqual(manifest.program, Manifest.Program(runner: Manifest.Runner
            .python, entry: "main.py", version: nil))
        // Check inputs section
        XCTAssertEqual(manifest.inputs, [Manifest.Input(name: "in-file", type: Manifest.DataType.path, comment: nil)])
        // Check oututs section
        XCTAssertEqual(manifest.outputs, [Manifest.Output(name: "output1", comment: nil)])
    }
    func testPythonCommented() throws {
        // Attempt to parse
        let manifest = try Manifest.fromString(source: Manifests.pythonCommented)
        // Check program section
        XCTAssertEqual(manifest.program,
                       Manifest.Program(runner: Manifest.Runner.python, entry: "main.py", version: nil))
        // Check inputs section
        XCTAssertEqual(manifest.inputs, [
            Manifest.Input(name: "inputImage", type: Manifest.DataType.path, comment: "The image to process"),
            Manifest.Input(name: "timeout", type: Manifest.DataType.int, comment: "Time in seconds to allow script to run")
        ])
        // Check oututs section
        XCTAssertEqual(manifest.outputs, [Manifest.Output(name: "output1", comment: "This is the first output")])
    }
    func testEmpty() {
        // Supply empty string to parser, ensure an error is thrown
        XCTAssertThrowsError(try Manifest.fromString(source: ""))
    }
}
