//
//  CharacterReader.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol CharacterReader {
    associatedtype IndexType: Comparable

    typealias CharacterRange = Range<IndexType>

    var isAtEnd: Bool { get }
    var currentIndex: IndexType { get }
    var currentCharacter: Character { get }

    @discardableResult
    mutating func advanceIndex() -> Bool
}

extension CharacterReader {
    mutating func advanceAndGetRange() -> CharacterRange? {
        if isAtEnd {
            return nil
        }

        let start = currentIndex

        advanceIndex()

        precondition(start != currentIndex)

        return start..<currentIndex
    }

    mutating func advance(while predicate: (Character) -> Bool) -> CharacterRange? {
        if isAtEnd {
            return nil
        }

        let start = currentIndex

        while advanceIndex() {
            if !predicate(currentCharacter) {
                break
            }
        }

        if start == currentIndex {
            return nil
        }

        return start..<currentIndex
    }
}

extension CharacterReader {
    mutating func advance(whileInSet set: CharacterSet) -> CharacterRange? {
        return advance(while: { (c) -> Bool in
            return set.contains(c)
        })
    }
}
