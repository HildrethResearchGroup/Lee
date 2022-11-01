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
    private var editValue: String = ""
    
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
    
    var runnerEditView: some View {
        VStack {
            
        }
    }
    
    var body: some View {
        HStack {
            runnerListView
            runnerEditView
        }.padding(8)
    }
}
