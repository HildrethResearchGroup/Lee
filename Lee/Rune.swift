//
//  Rune.swift
//  Lee
//
//  Created by Mines Student on 10/7/22.
//

import Foundation

struct Rune {
    static func isValidRuneSchema(command: String) -> Bool {
        return false
    }
    static func isValidRuneCommand(command: String) -> Bool {
        return RuneCommands(rawValue: command) != nil
    }
    static func isValidRuneStart(command: String) -> Bool {
       return false
    }
    static func isValidRuneEnd(command: String) -> Bool {
        return false
    }
    static func isValidRuneFile(command: String) -> Bool {
        return false
    }
    static func isValidRuneError(command: String) -> Bool {
        return false
    }
}
