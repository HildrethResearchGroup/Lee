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
            viewModel.renameRunner(index: currentlyEditing!, newName: runnerNameEditValue)
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
    
    var runnerVersionListButtons: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "plus")
            } .buttonStyle(.borderless)
            Button {
                
            } label: {
                Image(systemName: "minus")
            } .buttonStyle(.borderless)
            Spacer()
        }
    }
    
    var runnerVersionList: some View {
        List(Array(viewModel.selectedRunnerVersions!.sorted(by: >)), id: \.key) {key, value in
            HStack {
                Text(key)
                Spacer()
                Text(value)
            }
        }
    }
    
    var runnerVersionEdit: some View {
        VStack {
            HStack {
                Text("Version")
                Spacer()
            }
            TextField("", text: $runnerVersionNameEditValue)
            HStack {
                Text("Executable")
                Spacer()
            }
            TextField("", text: $runnerVersionPathEditValue)
        }
        .multilineTextAlignment(.leading)
    }
    
    var body: some View {
        VStack {
            HStack {
                runnerListView
                if viewModel.selectedRunnerVersions != nil {
                    Spacer()
                    VStack {
                        runnerVersionList
                        runnerVersionListButtons
                            .padding(4)
                        runnerVersionEdit
                    }
                }
            }
            runnerListButtons
                .padding(4)
        }
        .padding(8)
    }
}
