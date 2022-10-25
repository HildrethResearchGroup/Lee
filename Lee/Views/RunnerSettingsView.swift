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
    private var runnerNamesSelection = Set<Int>()
    
    @State
    private var currentlyEditing: Int?
    
    @State
    private var runnerNameEditValue: String = ""
    
    @State
    private var runnerVersionNameEditValue: String = ""
    
    @State
    private var runnerVersionPathEditValue: String = ""
    
    @FocusState
    private var editFocus: Bool
    
    var runnerListButtons: some View {
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
    
    var runnerVersionListButtons: some View {
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
