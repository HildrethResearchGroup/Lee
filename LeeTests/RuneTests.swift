//
//  RuneTests.swift
//  LeeTests
//
//  Created by Mines Student on 10/8/22.
//

import XCTest
@testable import Lee


class RuneTests: XCTestCase {
    
    func testValidRUNEStart() {
        // Ensure that the start command works
        XCTAssertTrue(Rune.isValidRuneStart(command: "@$RUNE_START$@"))
    }
    
    func testInvalidRUNEStart() {
        // Ensures that only START initiates the program
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_start$@"))
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_Start$@"))
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_sTart$@"))
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_stArt$@"))
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_staRt$@"))
        XCTAssertFalse(Rune.isValidRuneStart(command: "@$RUNE_starT$@"))
    }
    
    func testValidRUNEEnd() {
        // Ensure that the end command works
        XCTAssertTrue(Rune.isValidRuneEnd(command: "@$RUNE_END$@"))
    }
    
    func testInvalidRUNEEnd() {
        // Ensures that only tht END command ends the program
        XCTAssertFalse(Rune.isValidRuneEnd(command: "@$RUNE_end$@"))
        XCTAssertFalse(Rune.isValidRuneEnd(command: "@$RUNE_End$@"))
        XCTAssertFalse(Rune.isValidRuneEnd(command: "@$RUNE_eNd$@"))
        XCTAssertFalse(Rune.isValidRuneEnd(command: "@$RUNE_enD$@"))
        
    }
    
    func testValidRUNEFile() {
        // Ensure that the file command works
        XCTAssertTrue(Rune.isValidRuneFile(command: "@$RUNE_FILE(file1)$@"))
    }
    
    func testInvalidRUNEFile() {
        // Ensure that only the command FILE starts reading into a file
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_file(file1)$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_File(file1)$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_fIle(file1)$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_fiLe(file1)$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_filE(file1)$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_file$@"))
        XCTAssertFalse(Rune.isValidRuneFile(command: "@$RUNE_file()$@"))
    }
    
    func testValidRUNEError() {
        // Ensure that the error command works
        XCTAssertTrue(Rune.isValidRuneError(command: "@$RUNE_ERROR(error)$@"))
    }
    
    func testInvalidRUNEError() {
        // Ensure that only the ERROR command signifies an error
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_error(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_Error(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_eRror(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_erRor(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_errOr(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_erroR(error)$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_error$@"))
        XCTAssertFalse(Rune.isValidRuneError(command: "@$RUNE_error()$@"))
    }
    
    func testValidRUNESchema() {
        // Ensure that the rune schema is followed
        XCTAssertTrue(Rune.isValidRuneSchema(command: "@$RUNE_TEST$@"))
        XCTAssertTrue(Rune.isValidRuneSchema(command: "@$RUNE_TESTA$@"))
        XCTAssertTrue(Rune.isValidRuneSchema(command: "@$RUNE_TESTB$@"))
        XCTAssertTrue(Rune.isValidRuneSchema(command: "@$RUNE_TESTC$@"))
    }
    
    func testInvalidRUNESchema() {
        // Ensure that wrong rune schema is noticed
        XCTAssertFalse(Rune.isValidRuneSchema(command: "$@RUNE_TEST@$"))
        XCTAssertFalse(Rune.isValidRuneSchema(command: "$@rune_TEST@$"))
        XCTAssertFalse(Rune.isValidRuneSchema(command: "$@RUNE_@$"))
        XCTAssertFalse(Rune.isValidRuneSchema(command: "$@TEST@$"))
        XCTAssertFalse(Rune.isValidRuneSchema(command: "$@@$"))
    }
    
    func testValidRUNECommand() {
        // Ensure that only valid commands pass
        XCTAssertTrue(Rune.isValidRuneCommand(command: "START"))
        XCTAssertTrue(Rune.isValidRuneCommand(command: "END"))
        XCTAssertTrue(Rune.isValidRuneCommand(command: "FILE"))
        XCTAssertTrue(Rune.isValidRuneCommand(command: "ERROR"))
    }
    
    func testInvalidRUNECommand() {
        // Ensure that invalid commands don't pass
        XCTAssertFalse(Rune.isValidRuneCommand(command: "start"))
        XCTAssertFalse(Rune.isValidRuneCommand(command: "stan"))
        XCTAssertFalse(Rune.isValidRuneCommand(command: "reset"))
        XCTAssertFalse(Rune.isValidRuneCommand(command: "EXIT"))
        XCTAssertFalse(Rune.isValidRuneCommand(command: ""))
    }
}
