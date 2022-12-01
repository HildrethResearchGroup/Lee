//
//  SettingsRunnerPathProvider.swift
//  Lee
//
//  Created by Mines Student on 11/17/22.
//

import Foundation

class SettingsRunnerProvider: RunnerProtocol {
    private let runnersStore = UserDefaults.standard
    
    func getRunnerPath(name: String, version: String?) -> URL? {
        if let entry = runnersStore.dictionary(forKey: name) {
            if entry.isEmpty {
                return nil
            }
            
            if version == nil {
                return URL(fileURLWithPath: entry.values.first! as? String ?? "")
            } else if let path = entry[version!], let path = path as? String {
                return URL(fileURLWithPath: path)
            }
        }
        
        return nil
    }
}
