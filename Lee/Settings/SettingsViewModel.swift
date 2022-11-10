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
    
    @Published public var runnerUUIDs: [UUID] = []
    
    public init() {
        runnerUUIDs = getRunnerUUIDs()
    }
    
    public func getRunnerUUIDs() -> [UUID] {
        // Check for saved list of UUIDs
        if let uuids = settingsStore.stringArray(forKey: "runners") {
            // Convert strings to UUIDs
            return uuids.map({ uuid in
                UUID(uuidString: uuid)!
            })
        }
        
        // Set default and return empty
        settingsStore.set([], forKey: "runners")
        return []
    }
    
    public func getRunnerName(_ uuid: UUID) -> String {
        let runner = lookupUUID(uuid)!
        
        // First item in runner string array is name
        return runner[0]
    }
    
    public func createRunner(_ name: String) {
        // Generate UUID for new runner
        let uuid = getNewUUID()
        
        // Make string array to be saved for runner
        let runner = [name]
        
        // Save new runner
        saveUUID(uuid, value: runner)
        runnerUUIDs.append(uuid)
        saveRunnerUUIDs()
    }
    
    private func lookupUUID(_ uuid: UUID) -> [String]? {
        return settingsStore.stringArray(forKey: uuid.uuidString)
    }
    
    private func saveUUID(_ uuid: UUID, value: [String]) {
        settingsStore.set(value, forKey: uuid.uuidString)
    }
    
    private func getNewUUID() -> UUID {
        // Generate random UUID
        var uuid = UUID()
        
        // Check uniqueness
        while lookupUUID(uuid) != nil {
            uuid = UUID()
        }
        
        return uuid
    }
    
    private func saveRunnerUUIDs() {
        settingsStore.set(runnerUUIDs, forKey: "runners")
    }
}
