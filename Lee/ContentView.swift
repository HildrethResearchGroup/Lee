//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI

// VIEW
struct ContentView: View {
    // Handy charge on which Property Wrapper t use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Current Manifest: \(viewModel.manifestPath)")
                switch viewModel.manifestStatus {
                case .good: Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                case .bad: Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                default: Spacer()
                }
                Spacer()
            }
            if case .bad(let message) = viewModel.manifestStatus {
                HStack {
                    Text("Error: \(message)")
                    Spacer()
                }
            }
            Spacer(minLength: 4.0)
            HStack {
                Button(action: viewModel.loadManifestFile) {
                    Text("Load File")
                }
                Spacer(minLength: 1.0)
                Button(action: run) {
                    Text("Run")
                }
            }
        }.padding(16)
    }
    func run() {

    }
    func loadFile() {

    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = LeeApp()
        ContentView(viewModel: dataModel)
    }
}
*/
