//
//  LeeDataModel.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/15/22.
//

import SwiftUI

// This is the Model
class LeeDataModel: ObservableObject {
    @Published var targetManifestPath: String = ""
    @Published var manifestStatus: ManifestStatus?
    var targetManifest: Manifest?
    func changeTargetManifest(newFilePath: String) {
        manifestStatus = ManifestStatus.loading
        targetManifestPath = newFilePath
        do {
            // Attempt to load from file
            let manifestUrl = URL(fileURLWithPath: targetManifestPath)
            let manifestSource = try String(contentsOf: manifestUrl)
            // Attempt to parse loaded source
            targetManifest = try Manifest.fromString(source: manifestSource)
        } catch let error {
            // Manifest loading or parsing failed, report error to user
            manifestStatus = ManifestStatus.error(error.localizedDescription)
        }
    }
}
