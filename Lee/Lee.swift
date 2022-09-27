//
//  Lee.swift
//  Lee
//
//  Created by Isabella Fernandes de Oliveira on 9/16/22.
//

import SwiftUI

@main
struct Lee: App{
    let lee = LeeApp()
    
    var body: some Scene{
        WindowGroup{
            ContentView(viewModel: lee)
        }
    }
}
