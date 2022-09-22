//
//  DataModel.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import Foundation

/// This class runs external scripts and tracks running state.
///
/// Use @MainActor on your View Model or Data Model (if it is acting as your view model) to make sure all published properties are run on the main thread
@MainActor
class PythonExectuor: ObservableObject {
    /// The filepath to the scripting program
    ///
    /// This filepath needs to be updated
    @Published var pythonProcessPath = "/usr/bin/python3"
    
    /// The filepath for the script to run
    ///
    /// This filepath needs to be updated
    @Published var filePath = "/Users/ohildret/Documents/Code/Research/Mines/ExamplePythonExectutor/ExamplePythonExectutor/argsTest.py"
    
    /// This is an argument being sent to the external script.
    @Published var integerToPass = 15
    
    /// Used to update the UI based upon if an external script is running or not
    @Published var scriptIsRunning = false
    
    
    
    /// This function runs the target external script
    ///
    /// The process is run asynchronously to make sure the main threed isn't blocked if the script takes a long time to run.
    func runScript() async {
        // Put async code in a Task to have it run off the main thread.  This way your GUI won't freeze up.
        Task {
            let executableURL = URL(fileURLWithPath: pythonProcessPath)
            self.scriptIsRunning = true
            
            let process = Process()
            process.executableURL = executableURL
            process.arguments = [filePath, String(integerToPass)]
            process.terminationHandler = {_ in
                /* The terminationHandler uses an "old school" escaping completion handler.
                 You can't rely on Swift's new async/await to know what to run on the main thread for you.
                 You need to wrap the property accesses in a DispatchQueue (old school style).
                 */
                DispatchQueue.main.async {
                    self.scriptIsRunning = false
                  }
                
                print("Process finished")
            }
            
            // This is a do-catch statement
            do {
                try process.run()
            } catch  {
                print(error)
            }
        }
    }
    
}
