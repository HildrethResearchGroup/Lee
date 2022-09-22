//
//  ManifestTests.swift
//  LeeTests
//
//  Created by Mines Student on 9/15/22.
//

import XCTest
@testable import Lee

struct Manifests {
    static let valid1: String = """
    {
        "program": {
            "runner": "python"
        },
        "inputs": [
            {
                "name": "in-file",
                "type": "path",
                "comment": "Input file"
            },
            {
                "name": "timeout",
                "type": "int",
                "comment": "Time to allow script to run"
            }
        ],
        "output": {
            "files":
                [
                    "output1"
                ]
        }
    }
    """
    static let valid2: String = """
    {
        "program": {
            "runner": "matlab"
        },
        "inputs": [
            {
                "name": "inputImage",
                "type": "path"
            },
            {
                "name": "outputNamePrefix",
                "type": "string"
            },
            {
                "name": "timeout",
                "type": "int",
                "min": 10,
                "max": 20
            }
        ],
        "output": {
            "files":
                [
                    "output2"
                ]
        }
    }
    """
}

class ManifestTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }
    func testValidManifestComment() {
        // Attempt to parse
        let manifest = Manifest.parseFromString(source: Manifests.valid1)
        XCTAssertNotNil(manifest)
        // Check program section
        XCTAssertEqual(manifest!.program.runner, Runner.python)
        // Check inputs section
        XCTAssertEqual(manifest!.inputs[0],
                       Parameter(name: "in-file", type: DataType.path, comment: "Input file"))
        XCTAssertEqual(manifest!.inputs[1],
                       Parameter(name: "timeout", type: DataType.int, comment: "Time to allow script to run"))
        // Check oututs section
        XCTAssertEqual(manifest!.output, Output(files: ["output1"]))
    }
    func testValidManifestNoComment() {
        // Attempt to parse
        let manifest = Manifest.parseFromString(source: Manifests.valid2)
        XCTAssertNotNil(manifest)
        // Check program section
        XCTAssertEqual(manifest!.program.runner, Runner.matlab)
        // Check inputs section
        XCTAssertEqual(manifest!.inputs[0],
                       Parameter(name: "inputImage", type: DataType.path, comment: nil))
        XCTAssertEqual(manifest!.inputs[2],
                       Parameter(name: "timeout", type: DataType.int, comment: nil))
        // Check oututs section
        XCTAssertEqual(manifest!.output, Output(files: ["output2"]))
    }
    func testEmptyManifest() {
        // Supply empty string to parser
        let manifest = Manifest.parseFromString(source: "")
        // Ensure nil is returned
        XCTAssertNil(manifest)
    }
}
