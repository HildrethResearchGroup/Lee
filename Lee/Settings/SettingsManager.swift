//
//  SettingsManager.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct SettingsManager {
    private static let settingsStore = UserDefaults(suiteName: "settings")!
    
    public static func getRunnerUUIDs() -> [UUID] {
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
    
    private static func lookupUUID(_ uuid: UUID) -> [String]? {
        return settingsStore.stringArray(forKey: uuid.uuidString)
    }
    
    private static func getNewUUID() -> UUID {
        // Generate random UUID
        var uuid = UUID()
        
        // Check uniqueness
        while lookupUUID(uuid) != nil {
            uuid = UUID()
        }
        
        return uuid
    }
}
