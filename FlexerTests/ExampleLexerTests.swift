//
//  ExampleLexerTests.swift
//  FlexerTests
//
//  Created by Matt Massicotte on 2020-04-27.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import XCTest
@testable import Flexer

enum ExampleTokenKind {
    case word
    case number
    case symbol
    case whitespace
}

typealias ExampleToken = Flexer.Token<ExampleTokenKind>

struct ExampleTokenSequence: Sequence, IteratorProtocol, StringInitializable {
    public typealias Element = ExampleToken

    private var lexer: BasicTextCharacterLexer

    public init(string: String) {
        self.lexer = BasicTextCharacterLexer(string: string)
    }

    public mutating func next() -> Element? {
        guard let token = lexer.peek() else {
            return nil
        }

        switch token.kind {
        case .lowercaseLetter, .uppercaseLetter, .underscore:
            guard let endingToken = lexer.nextUntil(notIn: [.lowercaseLetter, .uppercaseLetter, .underscore, .digit]) else {
                return nil
            }

            return ExampleToken(kind: .word, range: token.startIndex..<endingToken.endIndex)
        case .digit:
            guard let endingToken = lexer.nextUntil({ $0.kind != .digit }) else {
                return nil
            }

            return ExampleToken(kind: .number, range: token.startIndex..<endingToken.endIndex)
        case .newline, .tab, .space:
            guard let endingToken = lexer.nextUntil(notIn: [.newline, .tab, .space]) else {
                return nil
            }

            return ExampleToken(kind: .whitespace, range: token.startIndex..<endingToken.endIndex)
        default:
            break
        }

        guard let endingToken = lexer.nextUntil(in: [.newline, .tab, .space, .lowercaseLetter, .uppercaseLetter, .underscore, .digit]) else {
            return nil
        }

        return ExampleToken(kind: .symbol, range: token.startIndex..<endingToken.endIndex)
    }
}

class ExampleLexerTests: XCTestCase {
    func testTokens() {
        let string = "abc d_eF\t\t\tGhi123 JKL 123 **&\nz"
        var lexer = ExampleTokenSequence(string: string).lookAhead

        XCTAssertEqual(lexer.next(), ExampleToken(kind: .word, range: NSRange(0..<3), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(3..<4), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .word, range: NSRange(4..<8), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(8..<11), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .word, range: NSRange(11..<17), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(17..<18), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .word, range: NSRange(18..<21), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(21..<22), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .number, range: NSRange(22..<25), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(25..<26), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .symbol, range: NSRange(26..<29), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .whitespace, range: NSRange(29..<30), in: string))
        XCTAssertEqual(lexer.next(), ExampleToken(kind: .word, range: NSRange(30..<31), in: string))
        XCTAssertNil(lexer.next())
    }
}

