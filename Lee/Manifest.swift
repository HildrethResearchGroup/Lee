//
//  Manifest.swift
//  Lee
//
//  Created by Mines Student on 9/15/22.
//

import Foundation

// Custom errors for manifest parser
enum ManifestParseError: Error {
    case otherError(Error)
    case badProtocol
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
    /// - parameter url: URL of the manifest file to be parsed
    ///
    /// - throws ManifestParseError: if the manifest is not valid, a ManifestParseError will be thrown
    static func fromURL(url: URL) throws -> Manifest {
        // Check to ensure the URL points to a file
        if(!url.isFileURL) {
            throw ManifestParseError.badProtocol
        }
        
        do {
            // Convert to data
            let manifestData = try Data(contentsOf: url)
            
            // Attempt to parse manifest
            var manifest = try decoder.decode(self, from: manifestData)
            
            // Add root directory to manifest
            var rootDir = url
            rootDir.deleteLastPathComponent()
            manifest.rootDirectory = rootDir
            
            return manifest
        } catch let error as DecodingError {
            throw ManifestParseError.decodingFailure(error)
        } catch let error {
            throw ManifestParseError.otherError(error)
        }
    }
    let program: Program
    var rootDirectory: URL
    let inputs: [Input]
    let outputs: [Output]
}
