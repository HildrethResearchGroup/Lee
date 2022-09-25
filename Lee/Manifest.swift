//
//  Manifest.swift
//  Lee
//
//  Created by Mines Student on 9/15/22.
//

import Foundation

// Custom errors for manifest parser
enum ManifestParseError: Error {
    case badEncoding
    case decodingFailure(DecodingError)
}

struct Manifest: Codable {
    // Program section representation
    struct Program: Codable {
        // Possible programs to execute scripts
        enum Runner: String, Codable {
            case python
            case matlab
        }
        
        let runner: Runner
        let entry: String // Main file for script
        let version: String? // Optional runner version
    }
    
    // Representation of a single script input
    struct Input: Codable {
        // Datatype of input
        enum DataType: String, Codable {
            case path
            case string
            case int
            case float
        }
        
        let name: String
        let type: DataType
        let comment: String?
    }
    
    // Reusable decoder for parsing from string
    private static let decoder = JSONDecoder()
    
    // Attempt to parse a manifest from a string source
    static func fromString(source: String) throws -> Manifest {
        // Proceed only if the string can be converted to data
        if let manifestData = source.data(using: .utf8) {
            // Attempt to decode into manifest, throw error on failure
            do {
                return try decoder.decode(self, from: manifestData)
            } catch let error as DecodingError {
                // Rethrow as ManifestParseError
                throw ManifestParseError.decodingFailure(error)
            }
        } else {
            // Failed to convert to data, string had bad encoding
            throw ManifestParseError.badEncoding
        }
    }
    
    let program: Program
    let inputs: [Input]
    let output: [String]
}
