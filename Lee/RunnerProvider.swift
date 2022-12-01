//
//  RunnerPathProvider.swift
//  Lee
//
//  Created by Mines Student on 11/17/22.
//
import Foundation

protocol RunnerProtocol {
    func getRunnerPath(name: String, version: String?) -> URL?
}

class MockRunnerProvider: RunnerProtocol {
    let path: String
    
    public init(path: String) {
        self.path = path
    }
    
    func getRunnerPath(name: String, version: String?) -> URL? {
        return URL(fileURLWithPath: self.path)
    }
}
