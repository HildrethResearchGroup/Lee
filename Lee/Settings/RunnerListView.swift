//
//  RunnerListView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerListView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State var currentlyEditing: String?
    @State var selection = Set<String>()
    @State var editText: String = ""
    @FocusState var editFocus: Bool
    
    var body: some View {
        VStack {
            List(viewModel.runners, id: \.self, selection: $selection) { name in
                HStack {
                    if currentlyEditing == name {
                        TextField("", text: $editText)
                            .onSubmit {
                                viewModel.renameRunner(oldName: name, newName: editText)
                                currentlyEditing = nil
                            }
                            .focused($editFocus)
                            .task {
                                editFocus = true
                                selection.removeAll()
                                selection.insert(name)
                            }
                    } else {
                        Text(name)
                            .onTapGesture(count: 2, perform: {
                                DispatchQueue.main.async {
                                    editText = name
                                    currentlyEditing = name
                                }
                            })
                    }
                    Spacer()
                }

            }
            ListEditView(plus: {
                viewModel.createRunner("runner")
            }, minus: {
                viewModel.deleteRunners(selection)
            })
        }
    }
}
