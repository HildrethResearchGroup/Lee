//
//  LeeApp.swift
//  Lee
//
//  Created by Mines Student on 8/30/22.
//

import Foundation

// This is the VIEWMODEL
// needs to be published and content view needs to subscribe to it

class LeeApp: ObservableObject {
    @Published private var model = LeeDataModel()
    // Intent function for user selecting manifest
    func selectManifest(filename: String) {
        model.changeTargetManifest(newFilePath: filename)
    }
}
