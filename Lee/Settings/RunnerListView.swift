//
//  RunnerListView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerListView: View {
    var body: some View {
        VStack {
            List(["test"], id: \.self) { id in
                Text(id)
            }
            ListEditView(plus: {
                
            }, minus: {
                
            })
        }
    }
}
