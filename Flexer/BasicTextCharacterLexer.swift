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

public struct BasicTextCharacterIterator: IteratorProtocol {
    public typealias Index = String.Index
    public typealias Token = BasicTextCharacter<Index>

    private let digitSet = CharacterSet.decimalDigits
    private let uppercaseSet = CharacterSet.uppercaseLetters
    private let lowercaseSet = CharacterSet.lowercaseLetters
    private var characterIterator: CharacterRangePairIterator

    public init(string: String) {
        self.characterIterator = CharacterRangePairIterator(string: string)
    }

    public mutating func next() -> Token? {
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

public struct BasicTextCharacterSequence: Sequence, StringInitializable {
    public typealias Element = BasicTextCharacterIterator.Token

    let string: String

    public init(string: String) {
        self.string = string
    }

    public func makeIterator() -> BasicTextCharacterIterator {
        return BasicTextCharacterIterator(string: string)
    }
}

public struct Lexer<BaseSequence: Sequence> {
    public typealias Token = BaseSequence.Element

    public let tokens: BaseSequence
    private var lookAheadTokens: LookAheadSequence<BaseSequence>

    public init(sequence: BaseSequence) {
        self.tokens = sequence
        self.lookAheadTokens = tokens.lookAhead
    }
}

extension Lexer: LookAheadIteratorProtocol {
    public typealias Element = LookAheadSequence<BaseSequence>.Element

    public mutating func next() -> Element? {
        return lookAheadTokens.next()
    }

    public mutating func peek(distance: Int) -> Element? {
        return lookAheadTokens.peek(distance: distance)
    }
}

public typealias BasicTextCharacterLexer = Lexer<BasicTextCharacterSequence>

extension Lexer: StringInitializable where BaseSequence: StringInitializable {
    public init(string: String) {
        self.init(sequence: BaseSequence(string: string))
    }
}

extension Lexer where BaseSequence == BasicTextCharacterSequence {
    public mutating func nextUntil(notIn set: Set<BasicTextCharacterKind>) -> BasicTextCharacterSequence.Element? {
        return nextUntil({ set.contains($0.kind) == false })
    }

    public mutating func nextUntil(in set: Set<BasicTextCharacterKind>) -> BasicTextCharacterSequence.Element? {
        return nextUntil({ set.contains($0.kind) })
    }
}
