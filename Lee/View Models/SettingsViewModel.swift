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
        if let runnerNames = settingsStore.mutableSetValue(forKey: "runnerNames") as? Set<String> {
            self.runnerNames = runnerNames
        }
    }
    
    public func addRunner(name: String) {
        runnerNames.insert(name)
    }
    
    public func removeRunners(names: Set<String>) {
        for name in names {
            runnerNames.remove(name)
        }
    }
    
    @Published
    private(set) var runnerNames = Set<String>()
    
    private let settingsStore = UserDefaults(suiteName: "settings")!
}
