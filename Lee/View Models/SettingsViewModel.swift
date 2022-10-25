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
        if let _ = runnerNames.firstIndex(of: name) {
            print("Attempt to create duplicate runner")
        }
        
        runnerNames.append(name)
    }
    
    public func removeRunners(names: Set<String>) {
        for name in names {
            runnerNames.remove(at: runnerNames.firstIndex(of: name)!)
        }
    }
    
    public func renameRunner(oldName: String, newName: String) {
        if let index = runnerNames.firstIndex(of: oldName) {
            runnerNames[index] = newName
        }
    }
    
    @Published
    var runnerNames: [String] = []
    
    private let settingsStore = UserDefaults(suiteName: "settings")!
}
