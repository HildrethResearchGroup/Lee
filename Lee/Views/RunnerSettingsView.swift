 //
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
    @ObservedObject private(set) var viewModel: SettingsViewModel
    
    @State
    private var selection = Set<String>()
    
    @State
    private var currentlyEditing: String?
    
    @State
    private var editValue: String = ""
    
    @FocusState
    private var editFocus: Bool
    
    
    var runnerEditView: some View {
        HStack {
            RunnerNamesView(runnerNames: viewModel.runnerNames, viewModel: viewModel)
            Spacer()
            if let selected = viewModel.selectedRunner {
                let versions = viewModel.runnerVersions[selected].keys.sorted(by: <)
                
                RunnerEditView(versions: versions, viewModel: viewModel)
            }
        }
        .padding()
    }
    
    var body: some View {
        HStack {
            runnerListView
        }.padding(8)
    }
}
