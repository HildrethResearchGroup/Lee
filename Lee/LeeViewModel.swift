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
    ///The data model, default is LeeDataModel()
    @Published var dataModel = LeeDataModel()

    /// Manifest Status optional
    @Published var manifestStatus: ManifestStatus?
    /// Manifest path, defaults to empty string
    @Published var manifestPath: String = ""
    private var manifest : Manifest?
    // Intent function for user selecting manifest

    /// Intent function for user selecting manifest, will open new file chooser window for user
    /// Once user has selected a file, the function will update the manifest in the data model and return the status.
    ///
    /// - returns manifestStatus: Whether or not the chosen file is a valid JSON manifest conforming to RUNE protocols
    //MARK: Load Manifest File 
    func loadManifestFile() {
        // create a new window to choose a file
        var filename = ""
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
                manifestStatus = dataModel.changeTargetManifest(path: path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
                // saveFile(path)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    func runScript() async throws {
        do {
            try await dataModel.runScript()
        } catch {
            // not sure what would go here
            // TODO: error handling could go here instead of data model??
        }
    }
}