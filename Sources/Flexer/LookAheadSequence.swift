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
        if delta > 0 {
            for _ in 0..<delta {
                if let t = iterator.next() {
                    buffer.append(t)
                }
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
        return baseSequence.string
    }
}

public extension LookAheadSequence where Base: StringInitializable, Base.Element: TokenProtocol, Base.Element.Index == String.Index {
    func substring(for token: Base.Element) -> Substring {
        return substring(with: token.range)
    }
}
