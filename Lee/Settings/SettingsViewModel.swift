//
//  SettingsViewModel.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    private let settingsStore = UserDefaults(suiteName: "settings")!
    
    @Published public var runners: [String] = []
    @Published public var selectedRunner: String?
    @Published public var selectedRunnerVersions: [String: String] = [:]
    
    public init() {
        if let runners = settingsStore.stringArray(forKey: "__runners__") {
            self.runners = runners
        } else {
            settingsStore.set([], forKey: "__runners__")
        }
    }
    
    public func createRunner(_ name: String) {
        // Ensure name is valid
        var name = name
        while !validateRunnerName(name) {
            name.append("-new")
        }
        
        // Save new runner
        runners.append(name)
        saveRunners()
        settingsStore.set([:], forKey: name)
    }
    
    public func renameRunner(oldName: String, newName: String) {
        // Ensure new name is valid
        var name = newName
        while !validateRunnerName(name) {
            name.append("-new")
        }
        
        // Lookup index of old name
        if let index = runners.firstIndex(of: oldName) {
            runners[index] = name
            saveRunners()
        } else {
            print("Cannot rename runner, no runner with name '\(oldName)' exists")
            return
        }
        
        // Move runner entry
        var newEntry: [String: String] = [:]
        if let runnerEntry = settingsStore.dictionary(forKey: oldName) {
            newEntry = (runnerEntry as? [String: String])!
            settingsStore.removeObject(forKey: oldName)
        }
        
        settingsStore.set(newEntry, forKey: name)
    }
    
    public func deleteRunners(_ names: Set<String>) {
        // Delete runner entries
        for name in names {
            settingsStore.removeObject(forKey: name)
        }
        
        // Remove from runner list
        runners.removeAll(where: { name in
            names.contains(name)
        })
    }
    
    public func selectRunner(_ names: Set<String>) {
        if names.count == 1 {
            selectedRunner = names.first!
            selectedRunnerVersions = settingsStore.dictionary(forKey: names.first!) as? [String: String] ?? [:]
        } else {
            selectedRunner = nil
            selectedRunnerVersions.removeAll()
        }
    }
    
    public func createRunnerVersion(_ name: String) {
        // Ensure a runner is selected
        if selectedRunner != nil {
            // Ensure name uniqueness
            var name = name
            while !validateVersionName(name) {
                name.append("-new")
            }
            
            selectedRunnerVersions[name] = ""
            saveSelectedRunnerVersions()
        }
    }
    
    public func deleteRunnerVersion(_ name: String) {
        // Ensure a runner is selected
        if selectedRunner != nil {
            selectedRunnerVersions.removeValue(forKey: name)
            saveSelectedRunnerVersions()
        }
    }
    
    public func renameRunnerVersion(oldName: String, newName: String) {
        // Ensure a runner is selected
        if selectedRunner != nil {
            // Ensure new name is valid
            var name = newName
            while !validateVersionName(name) {
                name.append("-new")
            }
            
            if let path = selectedRunnerVersions[oldName] {
                // Move value
                selectedRunnerVersions[name] = path
                selectedRunnerVersions.removeValue(forKey: oldName)
                saveSelectedRunnerVersions()
            } else {
                print("Failed to rename runner version '\(oldName)', does not exist")
            }
        }
    }
    
    public func setRunnerVersionExecutable(versionName: String, path: String) {
        if selectedRunner != nil {
            selectedRunnerVersions[versionName] = path
            saveSelectedRunnerVersions()
        }
    }
    
    private func validateRunnerName(_ name: String) -> Bool {
        // Can't be empty
        if name.isEmpty {
            return false
        } else if name == "__runners__" {
            // Reserved key
            return false
        } else if settingsStore.object(forKey: name) != nil {
            // Key already exists
            return false
            
        }
        
        return true
    }
    
    private func validateVersionName(_ name: String) -> Bool {
        // Can't be empty
        if name.isEmpty {
            return false
        } else if selectedRunnerVersions[name] != nil {
            // Cannot already exist
            return false
        }
        
        return true
    }
    
    private func saveRunners() {
        settingsStore.set(runners, forKey: "__runners__")
    }
    
    private func saveSelectedRunnerVersions() {
        settingsStore.set(selectedRunnerVersions, forKey: selectedRunner!)
    }
}
