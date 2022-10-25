//
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
    @StateObject
    var viewModel: SettingsViewModel
    
    @State
    private var selection = Set<String>()
    
    @State
    private var editing: String?
    
    @State
    private var editValue: String = ""
    
    @FocusState
    private var editFocus: Bool
    
    
    var runnerEditView: some View {
        HStack {
            Button {
                viewModel.addRunner(name: "runner")
                editing = "runner"
                editValue = ""
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
                TextField(name, text: Binding(
                    get: {name}, set: { (val) in
                        editValue = val
                    }
                ))
                    .onSubmit {
                        viewModel.renameRunner(oldName: name, newName: editValue)
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
