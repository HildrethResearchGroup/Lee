//
//  LeeDataModel.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/15/22.
//

import SwiftUI
import PythonKit

///Enum for possible errors script can throw
enum ScriptErrors: Error {
    case badManifestError(String)
}

///Enum for status of the manifest
enum ManifestStatus: Equatable {
    case good
    case bad(error: String)
}

/// DataModel for Lee program
/// Contains the Manifest as well as script running and output functions
class LeeDataModel {
    var scriptIsRunning = false
    private var manifest: Manifest?
    /// This is the script output
    let output: [String] = []
    // MARK: Change target manifest
    /// Function to change the current target manifest file
    /// It will attempt to load and parse the manifest, then will return whether or not the manifest is good.
    ///
    /// Parameter path: The path of the manifest file to be loaded
    ///
    /// Returns ManifestStatus: if the manifest file is valid or not
    ///
    /// Throws Any errors due to loading or parsing will be caught, printed and returned
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
    // MARK: Run Script function

    /// This function will run the script that the dataModel currently has
    // TODO: document and finish/fix
    func runScript() async throws {
        // Only run the script if the manifest was loaded correctly
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
         Task {
             let executableURL = URL(fileURLWithPath: "/usr/bin/python3") // TODO: PUT THIS IN MANIFEST PARSER
             self.scriptIsRunning = true
             let process = Process()
             let outputPipe = Pipe()
             process.standardOutput = outputPipe
             process.executableURL = executableURL
             process.arguments = [manifest!.program.entry]
            //if manifest specifies inputs, go through that array and get names
             if !manifest!.inputs.isEmpty {
                 var inputsArray: [String] = []
                 for input in manifest!.inputs {
                     inputsArray.append(input.name)
                 }
                 process.arguments = inputsArray // sets the arguments of the scriot to inputs specified in manifest
             }
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
    // MARK: Get Output Function
    func getOutput() -> [String] {
        return output
    }

}
