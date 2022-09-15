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
        guard let path = bundle.path(forResource: "manifest", ofType: "json") else {
            XCTFail("Failed to load manifest")
            return
        }
        let source = try? String(contentsOfFile: path)
        
        let manifest = Manifest.parseFromString(source: source!)
        
        XCTAssertNotNil(manifest)
    }
}
