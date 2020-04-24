//
//  BasicTextLexer.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation



public struct BasicTextToken<Index: Comparable> {
    public enum Kind: Equatable {
        case tab
        case space
        case newline

        case lowercaseRun
        case uppercaseRun
        case numberRun
        case otherCharacter

        case singleQuote
        case doubleQuote
        case backtick

        case openBrace
        case closeBrace
        case openBracket
        case closeBracket
        case openParen
        case closeParen
        case lessThan
        case greaterThan

        case tilde
        case exclamation
        case question
        case at
        case percent
        case caret
        case ampersand
        case dollar
        case star
        case slash
        case pound
        case pipe
        case backslash
        case dash
        case plus
        case equals

        case period
        case comma
        case colon
        case semicolon
        case underscore
    }

    public var range: Range<Index>
    public var kind: Kind

    public init(kind: Kind, range: Range<Index>) {
        self.kind = kind
        self.range = range
    }

    init?(kind: Kind, range: Range<Index>?) {
        guard let range = range else {
            return nil
        }

        self.kind = kind
        self.range = range
    }
}

extension BasicTextToken where Index == String.Index {
    public init?(kind: Kind, range: NSRange, in string: String) {
        guard let stringRange = Range<String.Index>(range, in: string) else {
            return nil
        }

        self.kind = kind
        self.range = stringRange
    }
}

extension BasicTextToken: Comparable {
    public static func < (lhs: BasicTextToken<Index>, rhs: BasicTextToken<Index>) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
}

extension BasicTextToken: CustomStringConvertible {
    public var description: String {
        return "<\(type(of: self)) \(String(describing: kind)) \(range)>"
    }
}

public struct BasicTextLexer<Reader: CharacterReader>: BufferingLexer {
    public typealias TokenType = BasicTextToken<Reader.IndexType>

    public var tokenBuffer: [TokenType]
    public var reader: Reader
    private let digitSet = CharacterSet.decimalDigits
    private let uppercaseSet = CharacterSet.uppercaseLetters
    private let lowercaseSet = CharacterSet.lowercaseLetters

    public init(reader: Reader) {
        self.reader = reader
        self.tokenBuffer = []
    }

    public var isAtEnd: Bool {
        return reader.isAtEnd && tokenBuffer.isEmpty
    }

    private mutating func advanceAndMakeToken(_ kind: TokenType.Kind) -> TokenType? {
        let range = reader.advanceAndGetRange()

        return BasicTextToken(kind: kind, range: range)
    }

    public mutating func bufferNextToken() -> TokenType? {
        if reader.isAtEnd {
            return nil
        }

        let char = reader.currentCharacter

        switch char {
        case "\t": return advanceAndMakeToken(.tab)
        case "\n": return advanceAndMakeToken(.newline)
        case " ":  return advanceAndMakeToken(.space)
        case "'":  return advanceAndMakeToken(.singleQuote)
        case "\"": return advanceAndMakeToken(.doubleQuote)
        case "`":  return advanceAndMakeToken(.backtick)
        case "{":  return advanceAndMakeToken(.openBrace)
        case "}":  return advanceAndMakeToken(.closeBrace)
        case "[":  return advanceAndMakeToken(.openBracket)
        case "]":  return advanceAndMakeToken(.closeBracket)
        case "(":  return advanceAndMakeToken(.openParen)
        case ")":  return advanceAndMakeToken(.closeParen)
        case "<":  return advanceAndMakeToken(.lessThan)
        case ">":  return advanceAndMakeToken(.greaterThan)
        case "~":  return advanceAndMakeToken(.tilde)
        case "!":  return advanceAndMakeToken(.exclamation)
        case "?":  return advanceAndMakeToken(.question)
        case "@":  return advanceAndMakeToken(.at)
        case "%":  return advanceAndMakeToken(.percent)
        case "^":  return advanceAndMakeToken(.caret)
        case "&":  return advanceAndMakeToken(.ampersand)
        case "$":  return advanceAndMakeToken(.dollar)
        case "*":  return advanceAndMakeToken(.star)
        case "/":  return advanceAndMakeToken(.slash)
        case "#":  return advanceAndMakeToken(.pound)
        case "|":  return advanceAndMakeToken(.pipe)
        case "\\": return advanceAndMakeToken(.backslash)
        case "-":  return advanceAndMakeToken(.dash)
        case "+":  return advanceAndMakeToken(.plus)
        case "=":  return advanceAndMakeToken(.equals)
        case ".":  return advanceAndMakeToken(.period)
        case ",":  return advanceAndMakeToken(.comma)
        case "_":  return advanceAndMakeToken(.underscore)
        case ";":  return advanceAndMakeToken(.semicolon)
        case ":":  return advanceAndMakeToken(.colon)
        default:
            break
        }

        if digitSet.contains(char) {
            return bufferRun(in: digitSet, kind: .numberRun)
        }

        if lowercaseSet.contains(char) {
            return bufferRun(in: lowercaseSet, kind: .lowercaseRun)
        }

        if uppercaseSet.contains(char) {
            return bufferRun(in: uppercaseSet, kind: .uppercaseRun)
        }

        return advanceAndMakeToken(.otherCharacter)
    }

    private mutating func bufferRun(in set: CharacterSet, kind: TokenType.Kind) -> TokenType? {
        let range = reader.advance(whileInSet: set)

        return BasicTextToken(kind: kind, range: range)
    }
}
