//
//  LeeApp.swift
//  Lee
//
//  Created by Mines Student on 8/30/22.
//

import SwiftUI

@main
struct LeeApp: App {
    @StateObject var dataModel = PythonExectuor()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataModel: dataModel)
                .frame(minWidth: 400, minHeight: 300)
                .toolbar {  // Adding a tool bar button is easy
                    playButtonView
                    
                }
        }
    }
    
    // You can refactor complex views as properties or functions
    var playButtonView: some View {
        Button(action: runScript, label: {
            // One way to switch between types of views is to use Group view to encapsulate logic.
            Group {
                if dataModel.scriptIsRunning {
                    ProgressView()
                } else {
                    Image(systemName: "play.fill")
                }
            }
        }).disabled(dataModel.scriptIsRunning)
        .help(dataModel.scriptIsRunning ? Text("Script is Running") : Text("Run Script"))
        // adding .help to a view creates a tool tip.  Notice how we can use the '?' ternary operator to switch between states.
    }
    
    func runScript() {
        Task {
            await dataModel.runScript()
        }
    }
    

}
