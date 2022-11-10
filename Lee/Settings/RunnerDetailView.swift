//
//  RunnerDetailView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerDetailView: View {
    @State private var executableText: String = ""
    
    var body: some View {
        VStack {
            List(["1.0"], id: \.self) { id in
                Text(id)
            }
            ListEditView(plus: {
                
            }, minus: {
                
            })
            HStack {
                Text("Executable: ")
                TextField("Path", text: $executableText)
            }
        }
    }
}
