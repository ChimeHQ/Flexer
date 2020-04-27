//
//  LookAheadIteratorProtocol.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-25.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol LookAheadIteratorProtocol: IteratorProtocol {
    mutating func peek(distance: Int) -> Element?
}

public extension LookAheadIteratorProtocol {
    mutating func peek() -> Element? {
        return peek(distance: 1)
    }

    mutating func peekUntil(_ predicate: (Element) -> Bool, limit: Int = Int.max) -> Bool {
        for _ in 0..<limit {
            switch peek() {
            case .none:
                return false
            case let elem?:
                if predicate(elem) {
                    return true
                }
            }
        }

        return false
    }
}

public extension LookAheadIteratorProtocol {
    mutating func nextIf(_ predicate: (Element) -> Bool) -> Element? {
        guard let t = peek() else {
            return nil
        }

        if predicate(t) {
            return next()

        }

        return nil
    }

    @discardableResult
    mutating func nextUntil(_ predicate: (Element) -> Bool, limit: Int = Int.max) -> Element? {
        var last: Element? = nil

        for _ in 0..<limit {
            guard let elem = peek() else {
                return last
            }

            if predicate(elem) {
                return last
            }

            last = elem

            _ = next()
        }

        return last
    }
}
