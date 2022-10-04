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

enum ManifestStatus: Equatable {
    case good
    case bad(error: String)
}

// This is the Model
class LeeDataModel {
    var scriptIsRunning = false
    private var manifest: Manifest?
    // This is the script output
    let output: [String] = []
    func changeTargetManifest(path: String) -> ManifestStatus {
        do {
            // Attempt to load from file
            let manifestUrl = URL(fileURLWithPath: path)
            let manifestSource = try String(contentsOf: manifestUrl)
            // Attempt to parse loaded source
            manifest = try Manifest.fromString(source: manifestSource)
            return .good
        } catch let error {
            print(error)
            // Manifest loading or parsing failed, report error to user
            return .bad(error: error.localizedDescription)
        }
    }
    func runScript() async throws {
        // var input = targetManifest!.inputs[2].name
        // Only run the script if the manifest was loaded correctly
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
         Task {
             let executableURL = URL(fileURLWithPath: manifest!.program.entry)
             self.scriptIsRunning = true

             let process = Process()
             let outputPipe = Pipe()
             process.standardOutput = outputPipe
             process.executableURL = executableURL
             process.arguments = [manifest!.inputs[2].name]
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
             
             let outputHandle = outputPipe.fileHandleForReading
             outputHandle.readInBackgroundAndNotify()
             
             outputHandle.readabilityHandler = { pipe in
                 guard let currentOutput = String(data: pipe.availableData, encoding: .utf8) else {
                     print("Can't decode data")
                     return
                 }
             }
         }
        
    }
    func getOutput() -> [String] {
        return output
    }
}
