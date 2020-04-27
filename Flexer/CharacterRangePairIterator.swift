//
//  CharacterRangePairIterator.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-25.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public struct CharacterRangePairIterator: IteratorProtocol {
    public struct CharacterRangePair {
        public var character: Character
        public var range: Range<String.Index>
    }

    private let string: String
    private var currentIndex: String.Index

    public init(string: String) {
        self.string = string
        self.currentIndex = string.startIndex
    }

    public mutating func next() -> CharacterRangePair? {
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
