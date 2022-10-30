//
//  LeeDataModel.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/15/22.
//
import SwiftUI
import PythonKit

/// Enum for possible errors script can throw
enum ScriptErrors: Error {
    case badManifestError(String)
}

/// Enum for status of the manifest
enum ManifestStatus: Equatable {
    case good
    case bad(error: String)
}

enum ScriptStatus: Equatable {
    case running
    case done
    case hasNotRun
}

/// DataModel for Lee program
/// Contains the Manifest as well as script running and output functions
class LeeDataModel {
    var scriptIsRunning = false
    private var scriptStat: ScriptStatus?
    private var manifest: Manifest?
    /// This is the script output
    var scriptOutput: [String] = []
    var outputFilenames: [URL] = []
    
    // MARK: Change target manifest
    /// Function to change the current target manifest file
    /// It will attempt to load and parse the manifest, then will return whether or not the manifest is good.
    ///
    /// Parameter url: The url of the manifest file to be loaded
    ///
    /// Returns ManifestStatus: if the manifest file is valid or not
    ///
    /// Throws Any errors due to loading or parsing will be caught, printed and returned
    func changeTargetManifest(url: URL) -> ManifestStatus {
        // Attempt to load manifest from file
        if let potentialManifest = Manifest(url: url) {
            self.manifest = potentialManifest
            return .good
        }
        
        return .bad(error: "Fail")
    }
    // MARK: Run Script function
    /// This function will run the script that the dataModel currently has
    func runScript(action: @escaping () -> Void) async throws {
        // Only run the script if the manifest was loaded correctly
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
         Task {
             let executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/python3") // TODO: PUT THIS IN MANIFEST PARSER
             let scriptURL = manifest!.relativeTo(relativePath: manifest!.program.entry)
             self.scriptIsRunning = true
             scriptStat = .running
             let process = Process()
             let outputPipe = Pipe()
             process.standardOutput = outputPipe
             process.executableURL = executableURL
             process.arguments = [scriptURL]
            // if manifest specifies inputs, go through that array and get names
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
                // Get the piped standard output from the subprocess
                let outputHandle = outputPipe.fileHandleForReading
                let outputData = outputHandle.readDataToEndOfFile()
                if let processOutput = String(data: outputData, encoding: String.Encoding.utf8) {
                    try writeToFile(output: processOutput)
                    print("Output files written")
                    scriptOutput = processOutput.components(separatedBy: "\n")
                }
                 scriptStat = .done
             } catch {
                 print(error)
                 scriptStat = .hasNotRun
             }

             // Get the piped standard output from the subprocess
             let outputHandle = outputPipe.fileHandleForReading
             let outputData = outputHandle.readDataToEndOfFile()
             if let processOutput = String(data: outputData, encoding: String.Encoding.utf8) {
                 scriptOutput = processOutput.components(separatedBy: "\n")
                 
             }
         }
    }
    /// As script is running it will change the script status depending on what step it is on. This is a getter
    /// with a default that the program has not yet run.
    func getScriptStatus() -> ScriptStatus {
        return scriptStat ?? .done
    }
    
    // MARK: Get Output Function
    func getOutput() -> [String] {
        return scriptOutput
    }
   
    /// This function writes the output of the script to the files desinated in the manfest
    ///
    /// - parameter output: This is the output from the script
    func writeToFile(output: String) throws {
        for currentFile in manifest!.outputs {
            // Save the script's output for this desinated file
            var currentOutput = ""
            var foundFile = false
            // Iterating through the script's output to find where files are written
            for currentLine in output.components(separatedBy: "\n") {
                // Checking if the current line matches for any of the files
                if !foundFile && Rune.isValidRuneFile(command: currentLine, fileName: currentFile.name) {
                    foundFile = true
                } else if foundFile && Rune.isValidRuneSchema(command: currentLine) {
                    // Set up the file to write to given the output
                    let outputFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    var fileName = URL(fileURLWithPath: currentFile.name, relativeTo: outputFile)
                    fileName = fileName.appendingPathExtension(currentFile.extension)
                    outputFilenames.append(fileName)
                    // Write the script's output to the file
                    try currentOutput.write(to: fileName, atomically: true, encoding: .utf8)
                    print("Written to \(fileName)")
                    // Finished getting all output written to this file
                    foundFile = false
                    break
                } else if foundFile {
                    // Adding lines from the script's output to this desinated output
                    currentOutput += currentLine + "\n"
                }
            }
        }
    }

}
