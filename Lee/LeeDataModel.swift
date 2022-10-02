//
//  LeeDataModel.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/15/22.
//

import SwiftUI

enum ScriptErrors: Error {
    case badManifestError(String)
}

// This is the Model
class LeeDataModel: ObservableObject {
    @Published var targetManifestPath: String = ""
    @Published var manifestStatus: ManifestStatus?
    var targetManifest: Manifest?
    @Published var scriptIsRunning = false
    // This is the script output
    let output: [String] = []
    func changeTargetManifest(newFilePath: String) {
        manifestStatus = ManifestStatus.loading
        targetManifestPath = newFilePath
        do {
            // Attempt to load from file
            let manifestUrl = URL(fileURLWithPath: targetManifestPath)
            let manifestSource = try String(contentsOf: manifestUrl)
            // Attempt to parse loaded source
            targetManifest = try Manifest.fromString(source: manifestSource)
            manifestStatus = ManifestStatus.good
        } catch let error {
            print(error)
            // Manifest loading or parsing failed, report error to user
            manifestStatus = ManifestStatus.error(error.localizedDescription)
        }
    }
    func runScript() async throws {
        // var input = targetManifest!.inputs[2].name
        // Only run the script if the manifest was loaded correctly
        if manifestStatus != ManifestStatus.good {
            throw ScriptErrors.badManifestError("Improper manifest!")
        }
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
         Task {
             let executableURL = URL(fileURLWithPath: targetManifestPath)
             self.scriptIsRunning = true

             let process = Process()
             process.executableURL = executableURL
             process.arguments = [targetManifestPath, targetManifest!.inputs[2].name]
             process.terminationHandler = {_ in
             // The terminationHandler uses an "old school" escaping completion handler.
             // You can't rely on Swift's new async/await to know what to run on the main thread for you.
             // You need to wrap the property accesses in a DispatchQueue (old school style).
             DispatchQueue.main.async {
             self.scriptIsRunning = false
             }
                 print("Process finished")
             }

             // This is a do-catch statement
         do {
             try process.run()
             } catch {
                 print(error)
             }
         }
    }
    func getOutput() -> [String] {
        return output
    }
}
