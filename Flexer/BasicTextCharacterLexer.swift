//
//  BasicTextCharacterLexer.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol StringInitializable {
    init(string: String)
}

public enum BasicTextCharacterKind: Equatable {
    case tab
    case space
    case newline

    case lowercaseLetter
    case uppercaseLetter
    case digit
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

public typealias BasicTextCharacter = Token<BasicTextCharacterKind>

struct CharacterRangePairIterator: IteratorProtocol {
    struct CharacterRangePair {
        public var character: Character
        public var range: Range<String.Index>
    }

    let string: String
    var currentIndex: String.Index

    init(string: String) {
        self.string = string
        self.currentIndex = string.startIndex
    }

    mutating func next() -> CharacterRangePair? {
        if currentIndex >= string.endIndex {
            return nil
        }

        let idx = currentIndex

        currentIndex = string.index(after: currentIndex)

        let char = string[idx]
        let range = idx..<currentIndex

        return CharacterRangePair(character: char, range: range)
    }
}

public struct BasicTextCharacterSequence: Sequence, StringInitializable, IteratorProtocol {
    public typealias Element = BasicTextCharacter

    private let digitSet = CharacterSet.decimalDigits
    private let uppercaseSet = CharacterSet.uppercaseLetters
    private let lowercaseSet = CharacterSet.lowercaseLetters
    private var characterIterator: CharacterRangePairIterator

    public init(string: String) {
        self.characterIterator = CharacterRangePairIterator(string: string)
    }

    public mutating func next() -> Element? {
        guard let pair = characterIterator.next() else {
            return nil
        }

        let range = pair.range
        let char = pair.character

        switch char {
        case "\t": return BasicTextCharacter(kind: .tab, range: range)
        case "\n": return BasicTextCharacter(kind: .newline, range: range)
        case " ":  return BasicTextCharacter(kind: .space, range: range)
        case "'":  return BasicTextCharacter(kind: .singleQuote, range: range)
        case "\"": return BasicTextCharacter(kind: .doubleQuote, range: range)
        case "`":  return BasicTextCharacter(kind: .backtick, range: range)
        case "{":  return BasicTextCharacter(kind: .openBrace, range: range)
        case "}":  return BasicTextCharacter(kind: .closeBrace, range: range)
        case "[":  return BasicTextCharacter(kind: .openBracket, range: range)
        case "]":  return BasicTextCharacter(kind: .closeBracket, range: range)
        case "(":  return BasicTextCharacter(kind: .openParen, range: range)
        case ")":  return BasicTextCharacter(kind: .closeParen, range: range)
        case "<":  return BasicTextCharacter(kind: .lessThan, range: range)
        case ">":  return BasicTextCharacter(kind: .greaterThan, range: range)
        case "~":  return BasicTextCharacter(kind: .tilde, range: range)
        case "!":  return BasicTextCharacter(kind: .exclamation, range: range)
        case "?":  return BasicTextCharacter(kind: .question, range: range)
        case "@":  return BasicTextCharacter(kind: .at, range: range)
        case "%":  return BasicTextCharacter(kind: .percent, range: range)
        case "^":  return BasicTextCharacter(kind: .caret, range: range)
        case "&":  return BasicTextCharacter(kind: .ampersand, range: range)
        case "$":  return BasicTextCharacter(kind: .dollar, range: range)
        case "*":  return BasicTextCharacter(kind: .star, range: range)
        case "/":  return BasicTextCharacter(kind: .slash, range: range)
        case "#":  return BasicTextCharacter(kind: .pound, range: range)
        case "|":  return BasicTextCharacter(kind: .pipe, range: range)
        case "\\": return BasicTextCharacter(kind: .backslash, range: range)
        case "-":  return BasicTextCharacter(kind: .dash, range: range)
        case "+":  return BasicTextCharacter(kind: .plus, range: range)
        case "=":  return BasicTextCharacter(kind: .equals, range: range)
        case ".":  return BasicTextCharacter(kind: .period, range: range)
        case ",":  return BasicTextCharacter(kind: .comma, range: range)
        case "_":  return BasicTextCharacter(kind: .underscore, range: range)
        case ";":  return BasicTextCharacter(kind: .semicolon, range: range)
        case ":":  return BasicTextCharacter(kind: .colon, range: range)
        default:
            break
        }

        if digitSet.contains(char) {
            return BasicTextCharacter(kind: .digit, range: range)
        }

        if lowercaseSet.contains(char) {
            return BasicTextCharacter(kind: .lowercaseLetter, range: range)
        }

        if uppercaseSet.contains(char) {
            return BasicTextCharacter(kind: .uppercaseLetter, range: range)
        }

        return BasicTextCharacter(kind: .otherCharacter, range: range)
    }
}

public typealias BasicTextCharacterLexer = LookAheadSequence<BasicTextCharacterSequence>
