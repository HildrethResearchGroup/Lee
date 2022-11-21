//
//  SettingsView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject public var viewModel: SettingsViewModel
    
    private enum Tabs {
        case runner
    }
    
    var body: some View {
        TabView {
            RunnerSettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Runner", systemImage: "play.circle.fill")
                }
        }
        .frame(width: 800, height: 600, alignment: .center)
    }
}
