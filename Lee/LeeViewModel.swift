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

class LeeViewModel: ObservableObject {
    @Published var dataModel = LeeDataModel()
    @Published var manifestStatus: ManifestStatus?
    @Published var manifestPath: String = ""
    // Intent function for user selecting manifest
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
}
