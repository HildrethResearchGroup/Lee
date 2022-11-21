//
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            RunnerListView(viewModel: viewModel)
                .padding()
            RunnerDetailView(viewModel: viewModel)
                .padding()
        }
    }
}
