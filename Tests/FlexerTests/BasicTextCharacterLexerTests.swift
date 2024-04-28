//
//  BasicTextCharacterLexerTests.swift
//  FlexerTests
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import XCTest
@testable import Flexer

class BasicTextCharacterLexerTests: XCTestCase {
    func testPeekTwiceReturnsSameValue() {
        let string = "\t"
        var lexer = BasicTextCharacterLexer(string: string)

        let token = BasicTextCharacter(kind: .tab, range: NSRange(0..<1), in: string)

        XCTAssertEqual(lexer.peek(), token)
        XCTAssertEqual(lexer.peek(), token)
    }

    func testNextReturnsDifferentValue() {
        let string: String = "\t"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertNotNil(lexer.peek())
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .tab, range: NSRange(0..<1), in: string))
        XCTAssertNil(lexer.peek())
    }
}

extension BasicTextCharacterLexerTests {
    func testPeekNextPerformance() {
        var string = ""

        for _ in 0..<10000 {
            string += "abc 123 ;[];^^%\n"
        }

        self.measure {
            var lexer = BasicTextCharacterLexer(string: string)

            while lexer.peek() != nil {
                _ = lexer.next()
            }
        }
    }
}

extension BasicTextCharacterLexerTests {
    func testSingleLowercaseCharacter() {
        let string = "a"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(0..<1), in: string))
        XCTAssertNil(lexer.next())
    }

    func testMultiCharacterUppercaseRun() {
        let string = "ABC"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(0..<1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(1..<2), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(2..<3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testDigitRun() {
        let string = "123"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(0..<1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(1..<2), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(2..<3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testNextUntilWithNoMatch() {
        let string = " a "
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .space, range: NSRange(0..<1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(1..<2), in: string))

        let token = lexer.nextUntil(notIn: [.lowercaseLetter])

        XCTAssertEqual(token, BasicTextCharacter(kind: .space, range: NSRange(2..<3), in: string))
    }
}
