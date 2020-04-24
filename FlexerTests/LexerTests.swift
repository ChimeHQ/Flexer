//
//  LexerTests.swift
//  FlexerTests
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import XCTest
@testable import Flexer

class LexerTests: XCTestCase {
    func testPeekTwiceReturnsSameValue() {
        let string = "\t"
        var lexer = BasicTextLexer(reader: StringReader(string))

        let token = BasicTextToken(kind: .tab, range: NSRange(0..<1), in: string)

        XCTAssertNotNil(lexer.peek())
        XCTAssertEqual(lexer.peek(), token)
        XCTAssertEqual(lexer.peek(), token)
    }

    func testNextReturnsDifferentValue() {
        let string: String = "\t"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .tab, range: NSRange(0..<1), in: string))
        XCTAssertNil(lexer.peek())
    }
}

extension LexerTests {
    func testPeekNextPerformanceWithStringReader() {
        var string = ""

        for _ in 0..<10000 {
            string += "abc 123 ;[];^^%\n"
        }

        self.measure {
            var lexer = BasicTextLexer(reader: StringReader(string))

            while lexer.peek() != nil {
                lexer.next()
            }
        }
    }
}

extension LexerTests {
    func testSingleCharacterLowercaseRun() {
        let string = "a"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .lowercaseRun, range: NSRange(0..<1), in: string))
        XCTAssertNil(lexer.next())
    }

    func testMultiCharacterLowercaseRun() {
        let string = "abc"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .lowercaseRun, range: NSRange(0..<3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testMultiCharacterUppercaseRun() {
        let string = "ABC"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .uppercaseRun, range: NSRange(0..<3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testMixedCharacterWordRun() {
        let string = "AbcDef"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .uppercaseRun, range: NSRange(0..<1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .lowercaseRun, range: NSRange(1..<3), in: string))
        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .uppercaseRun, range: NSRange(3..<4), in: string))
        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .lowercaseRun, range: NSRange(4..<6), in: string))
        XCTAssertNil(lexer.next())
    }

    func testDigitRun() {
        let string = "1234567890"
        var lexer = BasicTextLexer(reader: StringReader(string))

        XCTAssertEqual(lexer.next(), BasicTextToken(kind: .numberRun, range: NSRange(0..<10), in: string))
        XCTAssertNil(lexer.next())
    }
}
