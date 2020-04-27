//
//  BasicTextCharacter.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-25.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public struct Token<Index: Comparable, Kind: Equatable> {
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

    public var lowerBound: Index {
        return range.lowerBound
    }

    public var upperBound: Index {
        return range.upperBound
    }
}

extension Token: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        return "<\(type(of: self)) \(String(describing: kind)) \(String(describing: range))>"
    }
}

extension Token where Index == String.Index {
    public init?(kind: Kind, range: NSRange, in string: String) {
        guard let stringRange = Range<String.Index>(range, in: string) else {
            return nil
        }

        self.kind = kind
        self.range = stringRange
    }
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

public typealias BasicTextCharacter<Index: Comparable> = Token<Index, BasicTextCharacterKind>
