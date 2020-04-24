//
//  UTF16Reader.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

struct UTF16Reader: CharacterReader {
    public typealias IndexType = String.UTF16View.Index

    let string: String
    public private(set) var currentIndex: IndexType

    public init(_ string: String) {
        self.string = string
        self.currentIndex = string.utf16.startIndex
    }

    public var isAtEnd: Bool {
        return currentIndex >= string.utf16.endIndex
    }

    public var currentCharacter: Character {
        let codeUnit = string.utf16[currentIndex]
        let scalar = Unicode.Scalar(codeUnit)!

        return Character(scalar)
    }

    @discardableResult
    public mutating func advanceIndex() -> Bool {
        currentIndex = string.utf16.index(after: currentIndex)

        return isAtEnd == false
    }
}

struct UTF8Reader: CharacterReader {
    public typealias IndexType = String.UTF8View.Index

    let string: String
    public private(set) var currentIndex: IndexType

    public init(_ string: String) {
        self.string = string
        self.currentIndex = string.utf8.startIndex
    }

    public var isAtEnd: Bool {
        return currentIndex >= string.utf8.endIndex
    }

    public var currentCharacter: Character {
        let codeUnit = string.utf8[currentIndex]
        let scalar = Unicode.Scalar(codeUnit)

        return Character(scalar)
    }

    @discardableResult
    public mutating func advanceIndex() -> Bool {
        currentIndex = string.utf8.index(after: currentIndex)

        return isAtEnd == false
    }
}
