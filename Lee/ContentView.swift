//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI

struct ContentView: View {
    // Handy charge on which Property Wrapper t use
    // https://swiftuipropertywrappers.com
    @ObservedObject var dataModel: PythonExectuor
    
    var body: some View {
        HStack {
            Button(action: loadFile) {
                Text("Load File")
            }
            TextField("Input Integer", value: $dataModel.integerToPass, format: .number)
                .disabled(dataModel.scriptIsRunning)    // Notice that you can dynamically disable views and more with Swift UI
                .frame(width: 100)
                .padding()
        }
        
    }
}

func loadFile(){
    let dialog = NSOpenPanel();

    dialog.title                   = "Choose a file| Our Code World";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.allowsMultipleSelection = false;
    dialog.canChooseDirectories = false;

    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file

        if (result != nil) {
            let path: String = result!.path
            
            // path contains the file path e.g
            // /Users/ourcodeworld/Desktop/file.txt
        }
        
    } else {
        // User clicked on "Cancel"
        return
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = PythonExectuor()
        ContentView(dataModel: dataModel)
    }
}
