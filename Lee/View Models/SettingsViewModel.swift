//
//  SettingsViewModel.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    public init() {
        if let runnerNames = settingsStore.stringArray(forKey: "runnerNames") {
            self.runnerNames = runnerNames
        }
    }
    
    public func addRunner(name: String) {
        var name = name
        
        while runnerNames.contains(name) {
            name.append("-new")
        }
        
        runnerNames.append(name)
        saveRunnerNames()
    }
    
    public func removeRunners(names: Set<String>) {
        runnerNames.removeAll(where: { name in
            return names.contains(name)
        })
        saveRunnerNames()
    }
    
    public func renameRunner(oldName: String, newName: String) {
        if validateRunnerName(name: newName), let index = runnerNames.firstIndex(of: oldName) {
            runnerNames[index] = newName
            saveRunnerNames()
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
    
    private func saveRunnerNames() {
        settingsStore.set(runnerNames, forKey: "runnerNames")
    }
    
    @Published
    var runnerNames: [String] = []
    
    private let settingsStore = UserDefaults(suiteName: "settings")!
}
