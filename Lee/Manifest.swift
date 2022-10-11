//
//  Manifest.swift
//  Lee
//
//  Created by Mines Student on 9/15/22.
//

import Foundation

// Custom errors for manifest parser
enum ManifestParseError: Error {
    case otherError(message: String)
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
    // MARK: Manifest Parser
    
    let program: Program
    let inputs: [Input]
    let outputs: [Output]
    
    private var rootDirectory: URL?
    
    public init(url: URL) throws {
        // Check to ensure the URL points to a file
        if !url.isFileURL {
            throw ManifestParseError.badProtocol
        }
        
        do {
            // Convert to data
            let manifestData = try Data(contentsOf: url)
            
            // Attempt to parse manifest
            let decoder = JSONDecoder()
            self = try decoder.decode(Manifest.self, from: manifestData)
            
            // Ensure that users can't specifiy a 'rootDirectory' key in manifest
            if self.rootDirectory != nil {
                throw ManifestParseError.otherError(message: "Root directory specified in manifest file")
            }
            
            // Add root directory to manifest
            var rootDir = url
            rootDir.deleteLastPathComponent()
            self.rootDirectory = rootDir
        } catch let error as DecodingError {
            throw ManifestParseError.decodingFailure(error)
        } catch let error {
            throw ManifestParseError.otherError(message: error.localizedDescription)
        }
    }
    
    
    public func relativeTo(relativePath: String) -> URL {
        return URL(string: relativePath, relativeTo: rootDirectory)!
    }
}
