import Foundation

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

// This junk is needed to get around the "mutating" modifier
public extension LookAheadSequenceReference {
    func peekUntil(_ predicate: (Element) -> Bool, limit: Int = Int.max) -> Bool {
        return internalSequence.peekUntil(predicate)
    }

    func nextIf(_ predicate: (Element) throws -> Bool) rethrows -> Element? {
        return try internalSequence.nextIf(predicate)
    }

    func skipIf(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try internalSequence.skipIf(predicate)
    }

    func nextUntil(_ predicate: (Element) throws -> Bool, limit: Int = Int.max) rethrows -> Element? {
        return try internalSequence.nextUntil(predicate, limit: limit)
    }

    func skipUntil(_ predicate: (Element) throws -> Bool, limit: Int = Int.max) rethrows -> Bool {
        return try internalSequence.skipUntil(predicate, limit: limit)
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
