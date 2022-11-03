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
                    runnerVersions.append(runner.versions)
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
    
    public func addRunnerVersion(name: String) {
        if let index = selectedRunner {
            var name = name
            while runnerVersions[index][name] != nil {
                name.append("-new")
            }
            runnerVersions[index][name] = ""
            saveRunners()
        }
    }
    
    public func removeRunners(indicies: Set<Int>) {
        runnerNames.remove(atOffsets: IndexSet(indicies))
        runnerVersions.remove(atOffsets: IndexSet(indicies))
        selectedRunner = nil
        saveRunners()
    }
    
    public func removeRunnerVersions(names: Set<String>) {
        if let index = selectedRunner {
            for name in names {
                runnerVersions[index].removeValue(forKey: name)
            }
            saveRunners()
        }
    }
    
    public func renameRunner(index: Int, newName: String) {
        if validateRunnerName(name: newName) {
            runnerNames[index] = newName
            saveRunners()
        }
    }
    
    public func setRunnerVersionExecutable(version: String, path: String) {
        if let index = selectedRunner, runnerVersions[index][version] != nil {
            runnerVersions[index][version] = path
            saveRunners()
        } else {
            print("No runner selected, cannot set runner version executable")
        }
    }
    
    public func renameRunnerVersion(prevName: String, newName: String) {
        if !validateRunnerName(name: newName) {
            print("Invalid runner version name: \(newName)")
            return
        }
        
        if let index = selectedRunner, runnerVersions[index][prevName] != nil {
            let val = runnerVersions[index][prevName]
            runnerVersions[index].removeValue(forKey: prevName)
            runnerVersions[index][newName] = val
        } else if selectedRunner == nil {
            print("No runner selected, cannot rename a version")
        } else {
            print("'\(newName)' is an already existing version")
        }
        
        saveRunners()
    }
    
    public func selectRunner(index: Int?) {
        selectedRunner = index
    }
    
    public func selectRunner(index: Int?) {
        selectedRunner = index
    }
    
    private func validateRunnerName(name: String) -> Bool {
        if name.isEmpty, runnerNames.firstIndex(of: name) != nil {
            return false
        }
        
        return true
    }
    
    private func validateRunnerVersionName(name: String) -> Bool {
        return !name.isEmpty
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
    
    @Published private(set) var runnerNames: [String] = []
    @Published private(set) var selectedRunner: Int?
    @Published private(set) var runnerVersions: [[String: String]] = []
    
    private let settingsStore = UserDefaults(suiteName: "settings")!
    private let decoder = PropertyListDecoder()
    private let encoder = PropertyListEncoder()
}
