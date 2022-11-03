//
//  RunnerEditView.swift
//  Lee
//
//  Created by Mines Student on 11/1/22.
//

import Foundation
import SwiftUI

struct RunnerEditView: View {
    let versions: [String]
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var selection = Set<String>()
    @State private var executableEdit: String = ""
    
    var body: some View {
        VStack {
            List(versions, id: \.self, selection: $selection) { version in
                Text(version)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            ListEditView(plus: {
                viewModel.addRunnerVersion(name: "version")
            }, minus: {
                viewModel.removeRunnerVersions(names: selection)
            })
            HStack {
                Text("Path: ")
                Spacer()
                TextField("", text: $executableEdit)
                Button("Browse") {
                    
                }
            }
            .disabled(selection.count != 1)
            Spacer(minLength: 48)
        }
    }
}
