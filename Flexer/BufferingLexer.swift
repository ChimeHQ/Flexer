//
//  BufferingLexer.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol BufferingLexer: Lexer {
    var tokenBuffer: [TokenType] { get set }

    mutating func bufferNextToken() -> TokenType?
}

public extension BufferingLexer {
    @discardableResult
    mutating func next() -> TokenType? {
        if tokenBuffer.isEmpty {
            return bufferNextToken()
        }

        return tokenBuffer.removeFirst()
    }

    mutating func peek(distance: Int) -> TokenType? {
        if distance == 0 {
            return tokenBuffer.first
        }

        let delta = distance - tokenBuffer.count
        let index = distance - 1

        if delta > 0 {
            for _ in 0..<delta {
                if let t = bufferNextToken() {
                    tokenBuffer.append(t)
                }
            }
        }

        if tokenBuffer.count <= index {
            return nil
        }

        return tokenBuffer[index]
    }
}
