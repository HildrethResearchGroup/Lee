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
                case .error: Image(systemName: "multiply.circle.fill").foregroundColor(.red)
                default: Spacer()
                }
                Spacer()
            }
            if case .error(let message) = viewModel.manifestStatus {
                HStack {
                    Text("Error: \(message)")
                    Spacer()
                }
            }
            Spacer(minLength: 4.0)
            HStack {
                Button(action: loadFile) {
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
        // create a new window to choose a file
        let dialog = NSOpenPanel()
        dialog.title                   = "Choose a file"
        dialog.showsResizeIndicator    = true; // allow resizing
        dialog.showsHiddenFiles        = false; // Manifest files shouldn't be hidden, could change if needed
        dialog.allowsMultipleSelection = false; // select only one right now, will change
        dialog.canChooseDirectories = false; // manifest files are not directories
        if dialog.runModal() ==  NSApplication.ModalResponse.OK {
            let result = dialog.url // Pathname of the file
            if result != nil {
                let path: String = result!.path
                viewModel.selectManifest(path: path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
                // saveFile(path)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
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
