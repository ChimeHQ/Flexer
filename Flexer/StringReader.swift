//
//  StringReader.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public struct StringReader: CharacterReader {
    public typealias IndexType = String.Index

    public let string: String
    public private(set) var currentIndex: String.Index

    public init(_ string: String) {
        self.string = string
        self.currentIndex = string.startIndex
    }

    public var isAtEnd: Bool {
        return currentIndex >= string.endIndex
    }

    public var currentCharacter: Character {
        return string[currentIndex]
    }

    @discardableResult
    public mutating func advanceIndex() -> Bool {
        currentIndex = string.index(after: currentIndex)

        return isAtEnd == false
    }
}
