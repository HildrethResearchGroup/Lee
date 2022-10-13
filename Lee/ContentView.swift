//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI
import QuickLook

/// This is the Lee View
struct ContentView: View {
    @State
    var url: URL?
    // Handy charge on which Property Wrapper to use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeViewModel
    var body: some View {
        VStack {
            // MARK: Manifest Path Display
            // TODO: make separate view
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
            Button("Preview") {
                        url = Bundle.main.url(forResource: "argsTest", withExtension: "py")
                    }.quickLookPreview($url)
            Spacer(minLength: 4.0)
            // MARK: Run and Load File Buttons
            // TODO: Make separate view
            HStack {
                Button(action: viewModel.loadManifestFile) {
                    Text("Load File")
                }
                Spacer(minLength: 1.0)
                Button(action: {
                    Task {
                        try await viewModel.runScript()
                    }
                }) {
                    Text("Run")
                }
            }
        }.padding(16)
    }

    
}



// Commented out to allow ease of use
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = LeeApp()
        ContentView(viewModel: dataModel)
    }
}
*/
