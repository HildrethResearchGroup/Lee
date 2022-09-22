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
        "outputs": [
            {
                "name": "out-file",
                "type": "path",
                "comment": "File to output data"
            }
        ]
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
                "type": "path",
                "comment": "Image to process",
                "extensions": [
                    "png",
                    "jpg"
                ]
            },
            {
                "name": "outputNamePrefix",
                "type": "string"
            },
            {
                "name": "timeout",
                "type": "int",
                "comment": "Time before killing script",
                "min": 10,
                "max": 20
            }
        ],
        "outputs": [
            {
                "name": "outputImage",
                "type": "path",
                "comment": "Processed image"
            }
        ]
    }
    """
}

class ManifestTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testValidManifest1() {
        // Attempt to parse
        let manifest = Manifest.parseFromString(source: Manifests.valid1);
        XCTAssertNotNil(manifest)
        
        // Check program section
        XCTAssertEqual(manifest!.program.runner, Runner.python)
        
        // Check inputs section
        XCTAssertEqual(manifest!.inputs[0],
                       Parameter(name: "in-file", type: DataType.path, comment: "Input file"))
        XCTAssertEqual(manifest!.inputs[1],
                       Parameter(name: "timeout", type: DataType.int, comment: "Time to allow script to run"))
    }
    
    func testValidManifest2() {
        // Attempt to parse
        let manifest = Manifest.parseFromString(source: Manifests.valid2);
        XCTAssertNotNil(manifest)
        
        // Check program section
        XCTAssertEqual(manifest!.program.runner, Runner.matlab)
        
        XCTFail()
    }
    
    func testEmptyManifest() {
        // Supply empty string to parser
        let manifest = Manifest.parseFromString(source: "")
        
        // Ensure nil is returned
        XCTAssertNil(manifest)
    }
}