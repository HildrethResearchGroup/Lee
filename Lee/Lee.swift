//
//  Lee.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/16/22.
//

import SwiftUI

@main
/// Main application of MacOS app Lee
struct Lee: App {
    let leeViewModel = LeeViewModel()
    let settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: leeViewModel)
        }
        Settings {
            SettingsView(viewModel: settingsViewModel)
        }
    }
}
