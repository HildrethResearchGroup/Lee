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
    case bad(error: String)
}

/// DataModel for Lee program
/// Contains the Manifest as well as script running and output functions
class LeeDataModel {
    let runnerProvider: RunnerProvider
    var scriptRunning = [String: Bool]()
    /// This is the scripts outputs
    var scriptOutput = [String: [String]]()
    private var scriptStat: ScriptStatus?
    var manifest: Manifest?
    var fileUrls = [URL]()
    var fileNames = [Manifest.Output]()

    public init(runnerProvider: RunnerProvider) {
        self.runnerProvider = runnerProvider
    }
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
        do {
            // Attempt to parse loaded source
            manifest = try Manifest(url: url)
            return .good
        } catch let error {
            print(error)
            // Manifest loading or parsing failed, report error to user
            return .bad(error: error.localizedDescription)
        }
    }
    
    // MARK: Run Scripts function
    
    /// This function runs multiple scripts from a manifest file.
    func runScripts(action: @escaping () -> Void) async throws {
         
        for currentScript in manifest!.scripts {
            do {
                let scriptURL = manifest!.relativeTo(relativePath: currentScript.program.entry)
                self.scriptRunning.updateValue(false, forKey: scriptURL)
                self.scriptOutput.updateValue([], forKey: scriptURL)
                try await runScript(scriptPath: scriptURL, manifest: currentScript) {
                    action()
                }
            } catch let error as ScriptError {
                scriptStat = .bad(error: error.localizedDescription) // set error description before updating content view
                let scriptURL = manifest!.relativeTo(relativePath: currentScript.program.entry)
                self.scriptRunning.removeValue(forKey: scriptURL)
                throw error // TODO: should it throw here?
            }
        }
    }
    
    // MARK: Run Script function

    /// This function will run the script that the dataModel currently has
    func runScript(scriptPath: String, manifest: Manifest.Script, action: @escaping () -> Void) async throws {
        // Only run the script if the manifest was loaded correctly
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
        let fileExists = FileManager.default.fileExists(atPath: scriptPath)
        if !fileExists {
            action()
            throw ScriptError.missingFile
        }
        Task {
            let executableURL = runnerProvider.getRunnerPath(name: manifest.program.runner.rawValue, version: manifest.program.version)
            let process = Process()
            let outputPipe = Pipe()
            // Checking if the file path is a valid path
            process.standardOutput = outputPipe
            process.executableURL = executableURL
            // if manifest specifies inputs, go through that array and get names
            var inputsArray: [String] = [scriptPath]
            if !manifest.inputs.isEmpty {
                for input in manifest.inputs {
                    inputsArray.append(input.name)
                }
            }
            process.arguments = inputsArray // sets the arguments of the script to inputs specified in manifest
            process.terminationHandler = {_ in
            // The terminationHandler uses an "old school" escaping completion handler.
            // You can't rely on Swift's new async/await to know what to run on the main thread for you.
            // You need to wrap the property accesses in a DispatchQueue (old school style).
            DispatchQueue.main.async {
                self.scriptRunning.updateValue(false, forKey: scriptPath)
                self.scriptStat = .running
            }
             print("Process finished")
            }

            // This is a do-catch statement
            do {
                try process.run()
                // Get the piped standard output from the subprocess
                let outputHandle = outputPipe.fileHandleForReading
                let outputData = outputHandle.readDataToEndOfFile()
                // Writing the output from each script to a file
                if let processOutput = String(data: outputData, encoding: String.Encoding.utf8) {
                    try writeToFile(manifest: manifest, output: processOutput)
                    self.scriptOutput.updateValue(processOutput.components(separatedBy: "\n"), forKey: scriptPath)
                }
                scriptStat = .done
            } catch {
                scriptStat = .hasNotRun
            }
            action()
         }
    }

    // MARK: Get outputs for each script
    func getOutputs() -> [String: [String]] {
        return self.scriptOutput
    }
    
    // MARK: Get Output Function
    func getOutput(scriptName: String) -> [String] {
        return self.scriptOutput[scriptName] ?? []
    }
    
    // MARK: Get Output Function
    func getOutputURLS(manifest: Manifest) -> [URL] {
        fileUrls = [URL]()
        for script in manifest.scripts{
            for file in script.outputs{
                let outputFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                var fileName = URL(fileURLWithPath: file.name, relativeTo: outputFile)
                fileName = fileName.appendingPathExtension(file.extension)
                self.fileUrls.append(fileName)
                print(fileName)
            }
        }
        return self.fileUrls
    }
    /// MARK: Get  status of running script
    func getScriptStatus() -> ScriptStatus {
             return scriptStat ?? .done
         }
    func getScriptNames() -> [Manifest.Output]{
        fileNames = [Manifest.Output]()
        for script in manifest!.scripts{
            for file in script.outputs{
                self.fileNames.append(file)
            }
        }
        return self.fileNames
    }
    /// This function writes the output of the script to the files desinated in the manfest
    ///
    /// - parameter output: This is the output from the script
    func writeToFile(manifest: Manifest.Script, output: String) throws {
        for currentFile in manifest.outputs {
            // Save the script's output for this desinated file
            var currentOutput = ""
            var foundFile = false
            // Iterating through the script's output to find where files are written
            for currentLine in output.components(separatedBy: "\n") {
                // Checking if the current line matches for any of the files
                if !foundFile && Rune.isValidRuneFile(command: currentLine, fileName: currentFile.name) {
                    foundFile = true
                } else if foundFile && Rune.isValidRuneSchema(command: currentLine) {
                    // Writing the error if it exists
                    if Rune.isValidRuneError(command: currentLine) {
                        // Getting the error
                        let values = Rune.extractInternalName(command: currentLine)
                        // Writing the error to the output file
                        currentOutput += "ERROR: " + values[1] + "\n"
                        // Continuing reading output since this isn't the termination of the script
                        continue
                    }
                    // Set up the file to write to given the output
                    let outputFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    var fileName = URL(fileURLWithPath: currentFile.name, relativeTo: outputFile)
                    fileName = fileName.appendingPathExtension(currentFile.extension)
                    // Write the script's output to the file
                    try currentOutput.write(to: fileName, atomically: true, encoding: .utf8)
                    // Finished getting all output written to this file'
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
