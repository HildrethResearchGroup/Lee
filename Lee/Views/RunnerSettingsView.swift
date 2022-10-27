 //
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
<<<<<<< HEAD
    @ObservedObject private(set) var viewModel: SettingsViewModel
    
    @State
    private var runnerNamesSelection = Set<Int>()
=======
    private func commitRunnerEdit() {
        viewModel.renameRunner(oldName: currentlyEditing!, newName: editValue)
        currentlyEditing = nil
    }
    
    private func makeRunnerListItem(name: String) -> some View {
        return HStack {
            if name != currentlyEditing {
                Text(name)
                    .onTapGesture(count: 2, perform: {
                        currentlyEditing = name
                        editValue = name
                    })
            } else {
                TextField("", text: $editValue)
                    .onSubmit {
                        commitRunnerEdit()
                    }
                    .focused($editFocus)
                    .task {
                        selection.removeAll()
                        selection.insert(name)
                        editFocus = true
                    }
            }
            Spacer()
        }
    }
>>>>>>> 6e7b7a1 (Better editing and focus control)
    
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
    
<<<<<<< HEAD
    var runnerListButtons: some View {
=======
    var runnerEditView: some View {
>>>>>>> 6e7b7a1 (Better editing and focus control)
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
