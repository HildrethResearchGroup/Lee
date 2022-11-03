//
//  LeeApp.swift
//  Lee
//
//  Created by Mines Student on 8/30/22.
//

import Foundation
import SwiftUI

// This is the VIEWMODEL
// needs to be published and content view needs to subscribe to it



// needs to be published and content view needs to subscribe to it
/// This is the view model for Lee
class LeeViewModel: ObservableObject {
    /// The data model, default is LeeDataModel()
    @Published var dataModel = LeeDataModel()
    @Published var scriptRun = false
    /// Manifest Status optional
    @Published var manifestStatus: ManifestStatus?
    /// Script Status optional
    @Published var scriptStatus: ScriptStatus?
    /// Manifest path, defaults to empty string
    @Published var manifestPath: String = ""
    /// Variable that tells content view if manifest was loaded successfully.
    @Published var loadedManifest = false
    /// Intent function for user selecting manifest, will open new file chooser window for user
    /// Once user has selected a file, the function will update the manifest in the data model and return the status.
    ///
    /// - returns manifestStatus: Whether or not the chosen file is a valid JSON manifest conforming to RUNE protocols
    // MARK: Load Manifest File 
    func loadManifestFile() {
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
                let path = result!.path
                manifestStatus = dataModel.changeTargetManifest(url: URL(fileURLWithPath: path))
                if manifestStatus == .good {
                    loadedManifest = true
                }
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
                // saveFile(path)
                
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    func runScript() async {
        do {
            try await dataModel.runScript {
                
            }
            DispatchQueue.main.async {
                self.scriptStatus = self.dataModel.getScriptStatus()
            }
            self.scriptRun = true
        } catch {
            
        }
        
    }
    func debug() {
        #if DEBUG
        if CommandLine.arguments.contains("-goodManifest") {
            dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/LeeTests/Manifests/python_commented.json"))
            print("good manifest loaded")
        }
        else if CommandLine.arguments.contains("-badManifest") {
            dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/PythonFiles/bad.py"))
            print("bad manifest loaded")
        }
        #endif
    }
    func returnFiles() -> [URL]{
        print(dataModel.outputFilenames)
        return(dataModel.outputFilenames)
    }
}

