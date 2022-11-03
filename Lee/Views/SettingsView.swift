//
//  SettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/18/22.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    public enum Tabs: Hashable {
        case runner
    }
    
    var body: some View {
        TabView {
            RunnerSettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Runner", systemImage: "play.circle.fill")
                }.tag(Tabs.runner)
        }.frame(width: 800, height: 500, alignment: .center)
    }
    
    @StateObject var viewModel: SettingsViewModel
}
