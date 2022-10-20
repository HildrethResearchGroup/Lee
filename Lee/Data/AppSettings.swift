//
//  Settings.swift
//  Lee
//
//  Created by Mines Student on 10/20/22.
//

import Foundation


class AppSettings: Codable, ObservableObject {
    enum CodingKeys: CodingKey {
        case runner
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        runner = try container.decode(RunnerSettings.self, forKey: .runner)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runner, forKey: .runner)
    }
    
    @Published
    public var runner: RunnerSettings
}
