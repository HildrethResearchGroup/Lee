//
//  Rune.swift
//  Lee
//
//  Created by Mines Student on 10/7/22.
//

import Foundation

struct Rune {
    /// This function determines if the string entered follows the rune schema
    /// - Rune Schema: @$RUNE_COMMAND$@
    ///
    /// - parameter command: The command to have its schema checked
    ///
    /// - returns Bool: true if command has good schema or false if it doesn't
    static func isValidRuneSchema(command: String) -> Bool {
        // Compare the command to the valid RUNE schema
        return command.range(of: #"\@\$RUNE_[A-Z]+(\([\w\d]+\))?\$\@"#, options: .regularExpression) != nil
    }
    /// This function determines if the string entered is a valid rune command or not.
    ///
    /// - parameter command: The command to verified
    ///
    /// - returns Bool: true if command is a valid enum and false if it isn't
    static func isValidRuneCommand(command: String) -> Bool {
        // Compares
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
