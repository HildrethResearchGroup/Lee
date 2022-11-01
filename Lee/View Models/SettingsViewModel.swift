//
//  SettingsViewModel.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct SavedRunner: Codable {
    let name: String
    let versions: [String: String]
}

class SettingsViewModel: ObservableObject {
    public init() {
        do {
            if let runnersAny = settingsStore.value(forKey: "runners"), let runnersData = runnersAny as? [Data] {
                let runners = try runnersData.map({ encodedRunner in
                    try decoder.decode(SavedRunner.self, from: encodedRunner)
                })
                
                for runner in runners {
                    runnerNames.append(runner.name)
                    
                }
            }
        } catch let err {
            print("Failed to decode stored settings: \(err.localizedDescription)")
        }
    }
    
    public func addRunner(name: String) {
        var name = name
        
        while runnerNames.contains(name) {
            name.append("-new")
        }
        
        runnerNames.append(name)
        runnerVersions.append([:])
        saveRunners()
    }
    
    public func removeRunners(indicies: Set<Int>) {
        runnerNames.remove(atOffsets: IndexSet(indicies))
        saveRunners()
    }
    
    public func renameRunner(index: Int, newName: String) {
        if validateRunnerName(name: newName) {
            runnerNames[index] = newName
            saveRunners()
            
        }
    }
    
    public func selectRunner(index: Int?) {
        if let index = index {
            selectedRunnerVersions = runnerVersions[index]
        } else {
            selectedRunnerVersions = nil
        }
    }
    
    private func validateRunnerName(name: String) -> Bool {
        if name.isEmpty {
            return false
        } else if runnerNames.firstIndex(of: name) != nil {
            return false
        }
        
        return true
    }
    
    private func saveRunners() {
        var savedRunners: [SavedRunner] = []
        for index in runnerNames.indices {
            savedRunners.append(SavedRunner(name: runnerNames[index], versions: runnerVersions[index]))
        }
        
        var encodedRunners: [Data] = []
        do {
            for savedRunner in savedRunners {
                encodedRunners.append(try encoder.encode(savedRunner))
            }
        } catch let err {
            print("Failed to encode settings: \(err.localizedDescription)")
            return
        }
        
        settingsStore.set(encodedRunners, forKey: "runners")
    }
    
    @Published
    var runnerNames: [String] = []
    
    @Published
    var selectedRunnerVersions: [String: String]?
    
    private var runnerVersions: [[String: String]] = []
    
    private let settingsStore = UserDefaults(suiteName: "settings")!
    private let decoder = PropertyListDecoder()
    private let encoder = PropertyListEncoder()
}
