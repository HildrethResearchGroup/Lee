//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI
import QuickLook
import Quartz
import AppKit
/// This is the Lee View
struct ContentView: View {
    // Handy charge on which Property Wrapper to use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeViewModel
    @State private var num = 0;
//    @Binding var fileDisp = URL
    @State var urls = [URL]()
    @State var outputNames = [Manifest.Output]()
    
//    let Nullurl: URL = $0
//    @State var newFile = Binding<URL?>(
//        get: { URL.init(string: "") },
//        set: { _ in URL.init(string: "")! }
//    )
    @State var newFile = URL(string: "")
    // State variable to get value inside each TextField for the parameters window.
    // Patamers window does not connect to dataModel at this point, so this is a placeholder.
    @State var tempInputValue: String = ""
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
                // TODO: account for dark mode
                Text("Parameters: ").font(.title)
                // for each parameter in view model, create a text field use manifest file
                // to get param name and data type
                VStack {
                    if viewModel.dataModel.manifest?.scripts != nil {
                        ForEach(viewModel.dataModel.manifest!.scripts, id: \.self) { script in
                            ForEach(script.inputs, id: \.self) { input in
                                HStack {
                                    Text(input.name)
                                    //TextField("enter value", text: $tempInputValue)
                                    SubView(model: viewModel)
                                }
                            }
                            
                        }
                    }
                    
                }
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
                }.disabled(viewModel.loadedManifest == false && viewModel.manifestStatus != .good)
                Spacer(minLength: 1.0)
                Button(action: {
                    Task {
                        urls = viewModel.getOutputURLS()
//                        outputNames = viewModel.getOutputNames()
                        print(urls)
                        print("end")
                    }
                })
                {
                    Text("Open Output Files")
                }
        }
        VStack(alignment: .leading) {
            ForEach(urls,id: \.self) { file in
                Text(file.path)
                QLImage(url: file)
            }
        }
        }.padding(16)
            .refreshable {
                await viewModel.runScript()
            }
    }
    
    
}

/// This is the SubView for each parameter text field so that values are not linked together
struct SubView: View {
       @ObservedObject var model: LeeViewModel
       @State var textValue = ""

       var body: some View {
           VStack {
               TextField("Enter value...", text: $textValue)
            }
        }
    // TODO: textValue needs to be sent to dataModel so that script has the value of
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
