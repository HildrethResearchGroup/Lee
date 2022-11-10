//
//  RunnerSettingsView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerSettingsView: View {
    var body: some View {
        HStack {
            RunnerListView()
                .padding()
            RunnerDetailView()
                .padding()
        }
    }
}
