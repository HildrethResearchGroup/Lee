//
//  SettingsViewModel.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    private let decoder = PropertyListDecoder()
    private let encoder = PropertyListEncoder()
    private let standardStore = UserDefaults.standard
    
    @Published
    public var settings: AppSettings
    
    public init() {
        // Try to load settings from system, else load defaults
        do {
            // Will fail if settings not present
            let encodedSettings = standardStore.data(forKey: "settings")!
            
            settings = try decoder.decode(AppSettings.self, from: encodedSettings)
        } catch {
            settings = AppSettings()
            saveSettings()
        }
    }
    
    public func saveSettings() {
        do {
            let encodedSettings = try encoder.encode(settings)
            standardStore.set(encodedSettings, forKey: "settings")
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
