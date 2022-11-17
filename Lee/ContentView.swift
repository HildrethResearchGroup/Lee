//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI

/// This is the Lee View
struct ContentView: View {
    // Handy charge on which Property Wrapper to use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeViewModel
    @State private var num = 0;
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
                
                Text("Current Script Status: ")
                switch viewModel.scriptStatus {
                case .done: Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                case .hasNotRun: Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                case .bad: Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                default: Spacer()
                }
            }
            if case .bad(let message) = viewModel.manifestStatus {
                HStack {
                    Text("Error: \(message)")
                    Spacer()
                }
            }
            if case .bad(let message) = viewModel.scriptStatus {
                HStack {
                    Text("Error: \(message)")
                    Spacer()
                }
                
            }
            Spacer(minLength: 4.0)
            // MARK: Run and Load File Buttons
            // TODO: Make separate view
            
            // Middle horizontal stack will store the parameters window and
            VStack {
                
                Text("Parameters: ").font(.title)
                HStack {
                    Text("value 1:")
                    TextField("integers", value: $num, format: .number)
                }
                /*ForEach(viewModel...<emojiCount], id: \.self){ emoji in
                    CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                } for each parameter in view model, create a text field
                 use manifest file to get param name and data type
                 */
                
            }
            .multilineTextAlignment(.leading)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .padding()
            
            Spacer(minLength: 4.0)
            
            HStack {
                Button(action: viewModel.loadManifestFile) {
                    Text("Load File")
                }
                Spacer(minLength: 1.0)
                Button(action: {
                    Task {
                        
                        await viewModel.runScript()
                    }
                }) {
                    Text("Run")
                }.disabled(viewModel.loadedManifest == false)
                
            }
        }.padding(16)
            .refreshable {
                await viewModel.runScript()
            }
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
