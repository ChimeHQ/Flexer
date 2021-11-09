//
//  BufferingSequence.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-24.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public struct LookAheadSequence<Base>: Sequence, LookAheadIteratorProtocol where Base : Sequence {
    public typealias Element = Base.Element

    let baseSequence: Base
    private var buffer: [Base.Element]
    private var iterator: Base.Iterator

    public init(_ baseSequence: Base) {
        self.baseSequence = baseSequence
        self.iterator = baseSequence.makeIterator()
        self.buffer = []
    }

    public mutating func next() -> Element? {
        if buffer.isEmpty {
            return iterator.next()
        }

        return buffer.removeFirst()
    }

    public mutating func peek(distance: Int = 1) -> Element? {
        if distance == 0 {
            return buffer.first
        }

        let delta = distance - buffer.count
        let index = distance - 1

        // fill buffer as needed
        for _ in 0..<delta {
            if let t = iterator.next() {
                buffer.append(t)
            }
        }

        if index >= buffer.endIndex {
            return nil
        }

        return buffer[index]
    }
}

public extension Sequence {
    var lookAhead: LookAheadSequence<Self> {
        return LookAheadSequence(self)
    }
}

extension LookAheadSequence: StringInitializable where Base: StringInitializable {
    public init(string: String) {
        self.init(Base(string: string))
    }

    public var string: String {
        self.baseSequence.string
    }
}

/// LookAheadSequence with reference semantics
///
/// This is a class wrapper around LookAheadSequence. Useful if you need to pass
/// around and operate on a single shared instance.
public class LookAheadSequenceReference<Base>: Sequence, LookAheadIteratorProtocol where Base : Sequence {
    public typealias Element = Base.Element
    var internalSequence: LookAheadSequence<Base>

    public init(_ sequence: LookAheadSequence<Base>) {
        self.internalSequence = sequence
    }

    public func next() -> Element? {
        return internalSequence.next()
    }

    public func peek(distance: Int = 1) -> Element? {
        return internalSequence.peek(distance: distance)
    }
}

extension LookAheadSequenceReference where Base : StringInitializable {
    public var string: String {
        return internalSequence.string
    }
}

public extension LookAheadSequence {
    /// LookAheadSequence wapper with reference semantics
    var reference: LookAheadSequenceReference<Base> {
        return LookAheadSequenceReference(self)
    }
}
