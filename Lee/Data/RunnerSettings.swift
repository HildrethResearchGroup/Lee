//
//  RunnerSettings.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation
import SwiftUI

class RunnerSettings: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case runners
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        runners = try container.decode([String : Runner].self, forKey: CodingKeys.runners)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runners, forKey: .runners)
    }
    
    @Published
    var runners: [String : Runner]
}
