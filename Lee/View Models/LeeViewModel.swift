//
//  LeeApp.swift
//  Lee
//
//  Created by Mines Student on 8/30/22.
//

import Foundation
import SwiftUI

// Status of manifest from parser
enum ManifestStatus {
    case none
    case good
    case loading
    case error(String)
}

// This is the VIEWMODEL
// needs to be published and content view needs to subscribe to it

class LeeViewModel: ObservableObject {
    @Published var dataModel = LeeDataModel()
    @Published var manifestPath: String = ""
    @Published var manifestStatus: ManifestStatus = .none
    
    private var manifest: Manifest?
    var scriptIsRunning = false
    
    
    // Intent function for user selecting manifest
    func selectManifest(path: String) {
        manifestStatus = ManifestStatus.loading
        manifestPath = path
        do {
            // Attempt to load from file
            let manifestUrl = URL(fileURLWithPath: manifestPath)
            let manifestSource = try String(contentsOf: manifestUrl)
            // Attempt to parse loaded source
            manifest = try Manifest.fromString(source: manifestSource)
            manifestStatus = .good
        } catch let error {
            // Manifest loading or parsing failed, report error to user
            manifestStatus = ManifestStatus.error(error.localizedDescription)
        }
    }
}
