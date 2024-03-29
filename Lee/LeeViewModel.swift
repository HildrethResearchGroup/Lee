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
    @Published var dataModel = LeeDataModel(runnerProvider: SettingsRunnerProvider())

    /// Manifest Status optional
    @Published var manifestStatus: ManifestStatus?
    /// Script Status optional
    @Published var scriptStatus: ScriptStatus?
    /// Manifest path, defaults to empty string
    @Published var manifestPath: String = ""
    // Intent function for user selecting manifest
    @Published var loadedManifest = false
    // TODO: Add error handling
    func getOutputURLS() -> [URL] {
        if let manifest = dataModel.manifest{
            return dataModel.getOutputURLS(manifest: dataModel.manifest!)
        }
        return [URL]()
    }
    func getOutputNames() -> [Manifest.Output] {
        dataModel.getScriptNames()
    }
    /// Intent function for user selecting manifest, will open new file chooser window for user
    /// Once user has selected a file, the function will update the manifest in the data model and return the status.
    ///
    /// - returns manifestStatus: Whether or not the chosen file is a valid JSON manifest conforming to RUNE protocols
    // MARK: Load Manifest File
    //This set of else-ifs are for the UI tests
    func loadManifestFile() {
        if ProcessInfo.processInfo.arguments.contains("good") {
            manifestStatus = dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/PythonFiles/manifest_multiple_scripts.json"))
            if manifestStatus == .good {
                loadedManifest = true
            }
        }
        else if ProcessInfo.processInfo.arguments.contains("bad") {
            manifestStatus = dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/PythonFiles/many.py"))
            if manifestStatus == .good {
                loadedManifest = true
            }
        }
        else if ProcessInfo.processInfo.arguments.contains("badScript") {
            manifestStatus = dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/PythonFiles/manifest_bad.json"))
            if manifestStatus == .good {
                loadedManifest = true
            }
        }
        else if ProcessInfo.processInfo.arguments.contains("input") {
            manifestStatus = dataModel.changeTargetManifest(url: URL(fileURLWithPath: "/Users/student/Developer/Lee/PythonFiles/manifest_input.json"))
            if manifestStatus == .good {
                loadedManifest = true
            }
        }
        else{
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
    }
    func runScript() async {
        do {
            try await dataModel.runScripts {
                DispatchQueue.main.async {
                                 self.scriptStatus = self.dataModel.getScriptStatus()
                             }
            }
        } catch {
            
        }
        
    }
    
    
}
