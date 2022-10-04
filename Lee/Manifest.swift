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

// MARK: - Manifest Enums, to be separated
struct Manifest: Codable {
    // Possible programs to execute scripts
    // TODO: Generalize to allow for user to add more Runners
    enum Runner: String, Codable {
        case python
        case matlab
    }
    /// Types for data
    enum DataType: String, Codable {
        case path
        case string
        case int
        case float
        case filepath
    }
    /// Program section representation
    struct Program: Codable, Equatable {
        let runner: Runner
        let entry: String // Main file for script
        let version: String? // Optional runner version
    }
    /// Representation of a single script input
    struct Input: Codable, Equatable {
        let name: String
        let type: DataType
        let comment: String?
    }
    /// Representation of a single script output
    struct Output: Codable, Equatable {
        let name: String
        let comment: String?
    }
    // Reusable decoder for parsing from string
    private static let decoder = JSONDecoder()
    // MARK: Manifest Parser
    
    /// The function will parse a given RUNE manifest file based on the enums
    ///
    /// - parameter source: The manifest file to be parsed
    ///
    /// - throws ManifestParseError: if the manifest is not valid, a ManifestParseError will be thrown
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
    let outputs: [Output]
}
