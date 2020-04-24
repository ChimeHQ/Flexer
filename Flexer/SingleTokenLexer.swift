//
//  SingleTokenLexer.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol SingleTokenLexer {
    associatedtype TokenType

    var isAtEnd: Bool { get }

    @discardableResult
    mutating func next() -> TokenType?
    mutating func peek() -> TokenType?
}

extension SingleTokenLexer {
    public mutating func peekUntil(_ predicate: (TokenType) -> Bool) -> Bool {
        for _ in 0..<10000 {
            switch peek() {
            case .none:
                return false
            case let token?:
                if predicate(token) {
                    return true
                }
            }
        }

        return false
    }

    @discardableResult
    public mutating func nextUntil(_ predicate: (TokenType) -> Bool) -> TokenType? {
        var last: TokenType? = nil

        for _ in 0..<10000 {
            switch peek() {
            case .none:
                return last
            case let token?:
                if !predicate(token) {
                    last = token

                    next()
                    continue
                }

                return last
            }
        }

        return last
    }

    public mutating func nextIf(_ predicate: (TokenType) -> Bool) -> TokenType? {
        guard let t = peek() else {
            return nil
        }

        if !predicate(t) {
            return nil
        }

        return next()
    }
}
