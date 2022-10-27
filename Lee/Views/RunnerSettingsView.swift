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
        selection.removeAll()
        DispatchQueue.main.async {
            viewModel.renameRunner(oldName: currentlyEditing!, newName: editValue)
            currentlyEditing = nil
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
            List(viewModel.runnerNames, id: \.self, selection: $selection) { name in
                if name != currentlyEditing {
                    Text(name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture(count: 2, perform: {
                            currentlyEditing = name
                            editValue = name
                        })
                } else {
                    TextField("", text: $editValue)
                        .onSubmit {
                            commitRunnerName()
                        }
                        .focused($editFocus)
                        .task {
                            selection.removeAll()
                            selection.insert(name)
                            editFocus = true
                        }
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
