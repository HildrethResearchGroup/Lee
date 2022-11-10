//
//  RunnerListView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
//

import Foundation
import SwiftUI

struct RunnerListView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            List(viewModel.runnerUUIDs, id: \.self) { uuid in
                Text(viewModel.getRunnerName(uuid))
            }
            ListEditView(plus: {
                viewModel.createRunner("runner")
            }, minus: {
                
            })
        }
    }
}
