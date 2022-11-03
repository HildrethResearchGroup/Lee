//
//  RunnerEditView.swift
//  Lee
//
//  Created by Mines Student on 11/1/22.
//

import Foundation
import SwiftUI

struct RunnerEditView: View {
    private func saveName() {
        selection.removeAll()
        DispatchQueue.main.async {
            viewModel.renameRunnerVersion(prevName: currentlyEditing!, newName: versionNameEdit)
            currentlyEditing = nil
        }
    }
    
    private func selectionChanged(selection: Set<String>) {
        if selection.count == 1 {
            executableEdit = viewModel.runnerVersions[viewModel.selectedRunner!][selection.first!]!
        } else {
            executableEdit = ""
        }
    }
    
    let versions: [String]
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var selection = Set<String>()
    @State private var executableEdit: String = ""
    @State private var versionNameEdit: String = ""
    @State private var currentlyEditing: String?
    @FocusState private var editFocus: Bool
    
    var body: some View {
        VStack {
            List(versions, id: \.self, selection: $selection) { version in
                if version != currentlyEditing {
                    Text(version)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture(count: 2, perform: {
                            currentlyEditing = version
                            versionNameEdit = version
                        })
                } else {
                    TextField("", text: $versionNameEdit)
                        .onSubmit(saveName)
                        .focused($editFocus)
                        .task {
                            selection.removeAll()
                            selection.insert(version)
                            editFocus = true
                        }
                }
            }.onChange(of: selection, perform: selectionChanged)
            ListEditView(plus: {
                viewModel.addRunnerVersion(name: "version")
            }, minus: {
                viewModel.removeRunnerVersions(names: selection)
            })
            HStack {
                Text("Path: ")
                Spacer()
                TextField("", text: $executableEdit, onEditingChanged: { changed in
                    if changed {
                        DispatchQueue.main.async {
                            viewModel.setRunnerVersionExecutable(version: selection.first!, path: executableEdit)
                        }
                    }
                })
                Button("Browse") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        executableEdit = panel.url?.path ?? ""
                        viewModel.setRunnerVersionExecutable(version: selection.first!, path: executableEdit)
                    }
                }
            }
            .disabled(selection.count != 1 && currentlyEditing == nil)
            Spacer(minLength: 48)
        }
    }
}
