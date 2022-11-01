//
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
    private func commitRunnerName() {
        runnerNamesSelection.removeAll()
        DispatchQueue.main.async {
            viewModel.renameRunner(index: currentlyEditing!, newName: runnerNameEditValue)
            currentlyEditing = nil
        }
    }
    
    @StateObject
    var viewModel: SettingsViewModel
    
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
            Button {
                viewModel.addRunner(name: "runner")
            } label: {
                Image(systemName: "plus")
            }.buttonStyle(.borderless)
            Button {
                viewModel.removeRunners(indicies: runnerNamesSelection)
            } label: {
                Image(systemName: "minus")
            }.buttonStyle(.borderless)
            Spacer()
        }
    }
    
    var runnerListView: some View {
        VStack {
            List(viewModel.runnerNames.indices, id: \.self, selection: $runnerNamesSelection) { index in
                if index != currentlyEditing {
                    Text(viewModel.runnerNames[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture(count: 2, perform: {
                            currentlyEditing = index
                            runnerNameEditValue = viewModel.runnerNames[index]
                        })
                } else {
                    TextField("", text: $runnerNameEditValue)
                        .onSubmit {
                            commitRunnerName()
                        }
                        .focused($editFocus)
                        .task {
                            runnerNamesSelection.removeAll()
                            runnerNamesSelection.insert(index)
                            editFocus = true
                        }
                }
            }.onChange(of: runnerNamesSelection, perform: { selection in
                if selection.count == 1 {
                    viewModel.selectRunner(index: selection.first)
                } else {
                    viewModel.selectRunner(index: nil)
                }
            })
        }
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
