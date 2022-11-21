//
//  RunnerPathProvider.swift
//  Lee
//
//  Created by Mines Student on 11/17/22.
//

import Foundation

protocol RunnerProvider {
    func getRunnerPath(name: String, version: String?) -> URL?
}
