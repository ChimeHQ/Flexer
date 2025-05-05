//
//  TokenProtocol.swift
//  Flexer
//
//  Created by Matt Massicotte on 2020-04-27.
//  Copyright © 2020 Chime Systems Inc. All rights reserved.
//

import Foundation

public protocol TokenProtocol: Comparable, CustomStringConvertible {
	associatedtype Kind: Hashable
	associatedtype Index: Comparable

	var range: Range<Index> { get }
	var kind: Kind { get }

	init(kind: Kind, range: Range<Index>)
}

extension TokenProtocol where Index == String.Index {
	public init?(kind: Kind, range: NSRange, in string: String) {
		guard let stringRange = Range<String.Index>(range, in: string) else {
			return nil
		}

		self.init(kind: kind, range: stringRange)
	}

	public init?(kind: Kind, start: BasicTextCharacter, end: BasicTextCharacter?) {
		guard let end = end else { return nil }

		self.init(kind: kind, range: start.startIndex..<end.endIndex)
	}

	public func nsRange(in string: String) -> NSRange {
		return NSRange(range, in: string)
	}
}

extension TokenProtocol {
	public var startIndex: Index {
		return range.lowerBound
	}

	public var endIndex: Index {
		return range.upperBound
	}
}

extension TokenProtocol {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.startIndex < rhs.startIndex
	}
}

extension TokenProtocol {
	public var description: String {
		return "<\(type(of: self)) \(String(describing: kind)) \(String(describing: range))>"
	}
}

extension LookAheadSequence where Base.Element: TokenProtocol {
	public mutating func nextUntil(notIn set: Set<Element.Kind>) -> Base.Element? {
		return nextUntil({ set.contains($0.kind) == false })
	}

	public mutating func nextUntil(in set: Set<Element.Kind>) -> Base.Element? {
		return nextUntil({ set.contains($0.kind) })
	}
}

extension LookAheadSequence where Base.Element: TokenProtocol {
	public var tokens: Base {
		return baseSequence
	}
}

public struct Token<TokenKind: Hashable>: TokenProtocol {
	public typealias Kind = TokenKind
	public typealias Index = String.Index

	public var range: Range<Index>
	public var kind: Kind

	public init(kind: TokenKind, range: Range<Index>) {
		self.kind = kind
		self.range = range
	}
}
