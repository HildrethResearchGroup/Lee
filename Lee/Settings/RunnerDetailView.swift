//
//  RunnerDetailView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerDetailView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var executableText: String = ""
    @State private var selection: String?
    @State private var currentlyEditing: String?
    @State private var versionEditText: String = ""
    @FocusState private var editFocus: Bool
    
    var body: some View {
        VStack {
            List(Array((viewModel.selectedRunnerVersions).keys.sorted(by: >)),
                 id: \.self, selection: $selection) { name in
                if currentlyEditing == name {
                    TextField("", text: $versionEditText)
                        .onSubmit({
                            // Rename the version and disable editing
                            viewModel.renameRunnerVersion(oldName: name, newName: versionEditText)
                            currentlyEditing = nil
                        })
                        .focused($editFocus)
                        .task {
                            // Focus on field and select it
                            editFocus = true
                            selection = name
                        }
                } else {
                    Text(name)
                        .onTapGesture(count: 2, perform: {
                            // Toggle edit on double tap
                            DispatchQueue.main.async {
                                currentlyEditing = name
                                versionEditText = name
                            }
                        })
                }
            }
             .onChange(of: selection, perform: { selection in
                 if let selection = selection {
                     executableText = viewModel.selectedRunnerVersions[selection]!
                 } else {
                     executableText = ""
                 }
             })
            ListEditView(plus: {
                // Create a new version
                viewModel.createRunnerVersion("version")
            }, minus: {
                // Remove selected version
                if let selected = selection {
                    viewModel.deleteRunnerVersion(selected)
                }
            })
            HStack {
                Text("Executable: ")
                TextField("Path", text: $executableText)
                    .onSubmit {
                        saveExecutablePath()
                    }
            }
        }.disabled(viewModel.selectedRunner == nil)
    }
    
    private func saveExecutablePath() {
        if let selection = selection {
            viewModel.setRunnerVersionExecutable(versionName: selection, path: executableText)
        }
    }
}
