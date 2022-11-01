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
    private func commitRunnerName() {
        runnerNamesSelection.removeAll()
        DispatchQueue.main.async {
            viewModel.renameRunner(index: currentlyEditing!, newName: editValue)
            currentlyEditing = nil
        }
    }
    
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
