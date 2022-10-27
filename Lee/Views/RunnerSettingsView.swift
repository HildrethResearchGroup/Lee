//
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
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
    
    @StateObject
    var viewModel: SettingsViewModel
    
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
            Button {
                viewModel.addRunner(name: "runner")
            } label: {
                Image(systemName: "plus")
            }.buttonStyle(.borderless)
            Button {
                viewModel.removeRunners(names: selection)
            } label: {
                Image(systemName: "minus")
            }.buttonStyle(.borderless)
            Spacer()
        }
    }
    
    var runnerListView: some View {
        VStack {
            NavigationView {
                List(viewModel.runnerNames, id: \.self, selection: $selection) { name in
                    makeRunnerListItem(name: name)
                }
            }
            runnerEditView
                .padding(4)
        }
    }
    
    var body: some View {
        HStack {
            runnerListView
        }.padding(8)
    }
}
