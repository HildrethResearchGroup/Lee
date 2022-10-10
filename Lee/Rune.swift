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
        // Compares the string command to the available strings in the enum
        return RuneCommands(rawValue: command) != nil
    }
    /// This function extracts the command from the full rune schema.
    /// An example of this would be START from @$RUNE_START$@
    ///
    /// - parameter command: The full rune command to get the key command from
    ///
    /// - returns String: The extracted command from the rune command
    static func extractCommand(command: String) -> String {
        // Ensure that the command follows the rune schema
        if !isValidRuneSchema(command: command) {
           return ""
        }
        // Cut off the @$RUNE_ and $@ parts of the command
        let startIndex = command.index(command.startIndex, offsetBy: 7, limitedBy: command.endIndex)!
        let postCommand = String(command[startIndex..<command.endIndex])
        let endIndex = postCommand.index(postCommand.endIndex, offsetBy: -3)
        return String(postCommand[...endIndex])
    }
    /// This function verifies if the rune command is START
    ///
    ///  - parameter command: The command to check if it is a START rune command
    ///
    /// - returns Bool: true if the command is a start command and false if it isn't
    static func isValidRuneStart(command: String) -> Bool {
        // Ensure that the command follows the rune schema
        if !isValidRuneSchema(command: command) {
            return false
        }
        // Get the extracted command and verify that the command is START
        let extractedCommand = extractCommand(command: command)
        let checkEnum = isValidRuneCommand(command: extractedCommand)
        let checkStart = RuneCommands.START == RuneCommands(rawValue: extractedCommand)
        return checkEnum && checkStart
        
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
