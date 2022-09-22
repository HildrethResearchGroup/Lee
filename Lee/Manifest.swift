//
//  Manifest.swift
//  Lee
//
//  Created by Mines Student on 9/15/22.
//

import Foundation

enum Runner : String, Codable {
    case python, matlab
}

enum DataType : String, Codable {
    case path
    case string
    case int
}

struct Program : Codable {
    let runner: Runner
}

struct Parameter : Codable, Equatable {
    let name: String
    let type: DataType
    let comment: String?
}

struct Manifest : Codable {
    let program: Program
    let inputs: [Parameter]
    let outputs : [Parameter]
    
    static func parseFromString(source: String) -> Manifest? {
        var manifest: Manifest? = nil
        
        do {
            // Only parse the source if the source can be converted to data
            if let manifestData = source.data(using: .utf8) {
                let jsonDecoder = JSONDecoder()
                // Parse the manifest by splitting it into the Program, Inputs, and Outputs section.
                /*
                 Program - Specifies the program to run the script
                 Inputs - This will specify the script to run with the program specified in Program. Additionally, this specifies any arguments to pass the script, such as min, max, and time out values.
                 Outputs - This specifies the file to output the script's output too after it finishes running. It writes the values written to stdout to the output files in the order provided for both the script and the output file.
                 */
                manifest = try jsonDecoder.decode(Manifest.self, from: manifestData)
            }
        } catch {
            print ( error )
        }
        
        return manifest
    }
}
