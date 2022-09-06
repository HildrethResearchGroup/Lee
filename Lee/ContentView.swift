//
//  ContentView.swift
//  ExamplePythonExectutor
//
//  Created by Owen Hildreth on 8/25/22.
//

import SwiftUI

struct ContentView: View {
    // Handy charge on which Property Wrapper t use
    // https://swiftuipropertywrappers.com
    @ObservedObject var dataModel: PythonExectuor
    
    var body: some View {
        HStack {
            TextField("Input Integer", value: $dataModel.integerToPass, format: .number)
                .disabled(dataModel.scriptIsRunning)    // Notice that you can dynamically disable views and more with Swift UI
                .frame(width: 100)
                .padding()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataModel = PythonExectuor()
        ContentView(dataModel: dataModel)
    }
}
