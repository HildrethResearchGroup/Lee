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
            viewModel.renameRunner(index: currentlyEditing!, newName: editValue)
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
    private var editValue: String = ""
    
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
                            editValue = viewModel.runnerNames[index]
                        })
                } else {
                    TextField("", text: $editValue)
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
                }
            })
            runnerListButtons
                .padding(4)
        }
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
