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
                default: Spacer()
                }
            }
            if case .bad(let message) = viewModel.manifestStatus {
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
                }//.quickLookPreview($urls?)
//                ForEach($outputNames, id: \.self) { $name in
//                    Button("Preview") {
////                        var newFile: Binding<URL?> {
////                            Binding(
////                                get: { file },
////                                set: { file = $0 ?? URL.init(string: "")! }
////                            )
////                        }
//
//                        let outputFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                        newFile = URL(fileURLWithPath: name.name, relativeTo: outputFile)
//                        newFile = newFile!.appendingPathExtension(name.extension)
//                    }.quickLookPreview($newFile)
//                }
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



// Commented out to allow ease of use
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = LeeApp()
        ContentView(viewModel: dataModel)
    }
}
*/
