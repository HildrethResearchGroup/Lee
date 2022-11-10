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
    let lee = LeeViewModel()
    let settingsViewModel = SettingsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: lee)
        }
        Settings {
            SettingsView(viewModel: settingsViewModel)
        }
    }
}
