//
//  Manifest.swift
//  Lee
//
//  Created by Mines Student on 9/15/22.
//

import Foundation

enum Runner {
    case python, matlab
}

enum DataType {
    case path, string, int
}

struct Parameter {
    let name: String;
    let type: DataType;
    let comment: String?;
}

struct Manifest {
    let runner: Runner;
    let inputs: [Parameter];
    let outputs: [Parameter];
    
    static func parseFromString(source: String) -> Manifest? {
        nil
    }
}
