//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//
//import UIKit
import SwiftUI
import Quartz




/// This is the Lee View
struct ContentView: View {
    @State private var items: [QuickLookPreviewItem] = []
    @State private var index = 0
    @State
    var url: URL?
    // Handy charge on which Property Wrapper to use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeViewModel
    func debug(){
        viewModel.debug()
    }
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
//            let previewController = QLPreviewController()
//            previewController.dataSource = self
//            present(previewController, animated: true)
            if(viewModel.scriptRun){
                VStack(alignment: .leading) {
                    ForEach(viewModel.returnFiles(),id: \.self) { file in
                        Text("\(file)")
                        QLImage(url: file)
                   }
                    ZStack {
                        Button("Present QuickLook Preview") {
                            // Workaround needed because there's no way to know when the preview window is dismissed.
                            if self.items.isEmpty {
                                fillItems()
                            } else {
                                Task {
                                    self.items = []
                                    do { try await Task.sleep(nanoseconds: 0) } catch { fillItems() }
                                    fillItems()
                                }
                            }
                        }
                    }
                    .quickLookPreview(self.$items, at: self.$index)
                }
                
                func fillItems() {
                    self.items = viewModel.returnFiles()
                    self.index = self.items.count-1
                }
            }
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
