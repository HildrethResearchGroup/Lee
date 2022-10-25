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
    var selection = Set<String>()
    
    var runnerEditView: some View {
        HStack {
            Button {
                viewModel.addRunner(name: "Test")
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
            List(Array(viewModel.runnerNames), id: \.self, selection: $selection) { name in
                Text(name)
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
