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
    
    var body: some View {
        VStack {
            List(Array((viewModel.selectedRunnerVersions ?? [:]).keys.sorted(by: >)),
                 id: \.self, selection: $selection) { name in
                Text(name)
            }
            ListEditView(plus: {
                viewModel.createRunnerVersion("version")
            }, minus: {
                if let selected = selection {
                    viewModel.deleteRunnerVersion(selected)
                }
            })
            HStack {
                Text("Executable: ")
                TextField("Path", text: $executableText)
            }
        }.disabled(viewModel.selectedRunnerVersions == nil)
    }
}
