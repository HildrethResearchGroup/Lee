//
//  RunnerNamesListView.swift
//  Lee
//
//  Created by Mines Student on 11/1/22.
//

import Foundation
import SwiftUI

struct RunnerNamesView: View {
    private func saveName() {
        selection.removeAll()
        DispatchQueue.main.async {
            viewModel.renameRunner(index: currentlyEditing!, newName: editValue)
        }
    }
    
    private func selectionChanged(selection: Set<Int>) {
        if selection.count == 1 {
            viewModel.selectRunner(index: selection.first)
        } else {
            viewModel.selectRunner(index: nil)
        }
    }
    
    let runnerNames: [String]
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var selection = Set<Int>()
    @State private var currentlyEditing: Int?
    @State private var editValue: String = ""
    
    @FocusState private var editFocus: Bool
    
    var body: some View {
        VStack {
            List(runnerNames.indices, id: \.self, selection: $selection) { index in
                if index != currentlyEditing {
                    Text(runnerNames[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture(count: 2, perform: {
                            currentlyEditing = index
                            editValue = viewModel.runnerNames[index]
                        })
                } else {
                    TextField("", text: $editValue)
                        .onSubmit(saveName)
                        .focused($editFocus)
                        .task {
                            selection.removeAll()
                            selection.insert(index)
                            editFocus = true
                        }
                }
            }.onChange(of: selection, perform: selectionChanged)
            ListEditView(plus: {
                viewModel.addRunner(name: "runner")
            }, minus: {
                viewModel.removeRunners(indicies: selection)
            })
        }
    }
}
