//
//  ManifestTests.swift
//  LeeTests
//
//  Created by Mines Student on 9/15/22.
//
import XCTest
@testable import Lee

class ManifestTests: XCTestCase {
    let bundle = Bundle(for: ManifestTests.self)
    
    override func setUp() {
        continueAfterFailure = false
    }
    func testPythonSimple() throws {
        // Get manifest URL
        let url = bundle.url(forResource: "python_simple", withExtension: "json")
        
        // Attempt to parse
        let manifest = try Manifest(url: url!)
        
        // Check program section
        XCTAssertEqual(manifest.program, Manifest.Program(runner: Manifest.Runner
            .python, entry: "main.py", version: nil))
        // Check inputs section
        XCTAssertEqual(manifest.inputs, [Manifest.Input(name: "in-file", type: Manifest.DataType.path, comment: nil)])
        // Check oututs section
        XCTAssertEqual(manifest.outputs, [Manifest.Output(name: "output1", comment: nil)])
    }
    func testPythonCommented() throws {
        let url = bundle.url(forResource: "python_commented", withExtension: "json")
        
        // Attempt to parse
        let manifest = try Manifest(url: url!)
        
        // Check program section
        XCTAssertEqual(manifest.program,
                       Manifest.Program(runner: Manifest.Runner.python, entry: "main.py", version: nil))
        
        // Check inputs section
        XCTAssertEqual(manifest.inputs, [
            Manifest.Input(name: "inputImage", type: Manifest.DataType.path, comment: "The image to process"),
            Manifest.Input(name: "timeout", type: Manifest.DataType.int,
                           comment: "Time in seconds to allow script to run")
        ])
        
        // Check oututs section
        XCTAssertEqual(manifest.outputs, [Manifest.Output(name: "output1", comment: "This is the first output")])
    }
}
