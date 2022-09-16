//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI

//VIEW
struct ContentView: View {
    // Handy charge on which Property Wrapper t use
    // https://swiftuipropertywrappers.com
    @ObservedObject var viewModel: LeeApp
    
    var body: some View {
        HStack {
            Button(action: loadFile) {
                Text("Load File")
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
                viewModel.saveFile(path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
                //saveFile(path)
                
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
