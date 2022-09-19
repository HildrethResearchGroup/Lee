//
//  ManifestTests.swift
//  LeeTests
//
//  Created by Mines Student on 9/15/22.
//

import XCTest
@testable import Lee

class ManifestTests: XCTestCase {
    
    func testParseManifest() throws {
        let bundle = Bundle(for: type(of: self))
        // Get the path of the test file "manifest.json"
        guard let path = bundle.path(forResource: "manifest", ofType: "json") else {
            XCTFail("Failed to load manifest")
            return
        }
        
        // Read all the text from the test file
        let source = try? String(contentsOfFile: path)
        
        // Error if the file doesn't have text
        XCTAssertNotNil(source)
        
        // Parse the data from the manifest
        let manifest = Manifest.parseFromString(source: source!)
        
        // Error if the manifest isn't parsed
        XCTAssertNotNil(manifest)
        
        // This section checks if the parsed file has valid entires
        
        // Checks the Program section
        // Checks if the runner string contains a value
        XCTAssertFalse(((manifest?.program.runner.isEmpty) != nil))
        
        
    }
    
    
}
