<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Matrix][matrix badge]][matrix]

</div>

# Flexer

Flexer is a small library for building lexers in Swift. It is compatible with all Apple platforms.

- API tailored for hand-written parsing
- Fully Swift `String`-compatible
- Based around `Sequence` and `IteratorProtocol` procotols

It turns out that Swift's `Sequence` and `Iterator` concepts work pretty well for processing tokens. They make for a familiar API that also offers a surprising amount of power. Flexer builds on these concepts with some new protocols that are made specifically for lexing, but are generally applicable to all `Sequence` types.

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Flexer")
]
```

## Look-Ahead

Core to lexing is the ability to look ahead at future tokens without advancing. Flexer implements look-ahead with a protocol called `LookAheadIteratorProtocol`. The whole implementation is inspired by the `lazy` property of `Sequence`, and works very similarly.

```swift
let lookAheadSequence = anySequence.lookAhead

let next = lookAheadSequence.peek()
```

The main work of building your lexer is then defining a Sequence type of tokens. All of the lexing facilities you might need can then be exposed with a `typealias`.

```swift
typealias MyLexer = LookAheadSequence<MyTokenSequence>
  
let tokenSequence = MyLexer(string: myString)

let nextToken = lexer.next()
let futureToken = lexer.peek()
let tabToken = lexer.nextUntil({ $0.kind == .tab })
```

## Token Sequences

Your custom token sequence can be built by creating a struct that conforms to `Sequence`. To make this easier, Flexer includes a type that can be used as a foundation for creating more complex token streams, called `BasicTextCharacterSequence`. It is a sequence of `BasicTextCharacter` elements. It breaks up a string into commonly-needed tokens, catagorized by kind and range within the source string. This approach uses the `Token` type, which stores a kind and a range within the source string.

It is usually much easier to build up more complex lexing functionality with the convenience of Swift switch pattern matching, instead of having to worry about the underlying characters and ranges themselves. You can do this by wrapping up a `BasicTextCharacterSequence` in your own custom sequence.

Here's a fully-functioning example that produces four different token types. It shows off some of the scanning and look-ahead facilities that can be handy both for constructing and also using your lexer.

```swift
enum ExampleTokenKind {
    case word
    case number
    case symbol
    case whitespace
}

typealias ExampleToken = Flexer.Token<ExampleTokenKind>

struct ExampleTokenSequence: Sequence, IteratorProtocol, StringInitializable {
    public typealias Element = ExampleToken

    private var lexer: BasicTextCharacterLexer

    public init(string: String) {
        self.lexer = BasicTextCharacterLexer(string: string)
    }

    public mutating func next() -> Element? {
        guard let token = lexer.peek() else {
            return nil
        }

        switch token.kind {
        case .lowercaseLetter, .uppercaseLetter, .underscore:
            guard let endingToken = lexer.nextUntil(notIn: [.lowercaseLetter, .uppercaseLetter, .underscore, .digit]) else {
                return nil
            }

            return ExampleToken(kind: .word, range: token.startIndex..<endingToken.endIndex)
        case .digit:
            guard let endingToken = lexer.nextUntil({ $0.kind != .digit }) else {
                return nil
            }

            return ExampleToken(kind: .number, range: token.startIndex..<endingToken.endIndex)
        case .newline, .tab, .space:
            guard let endingToken = lexer.nextUntil(notIn: [.newline, .tab, .space]) else {
                return nil
            }

            return ExampleToken(kind: .whitespace, range: token.startIndex..<endingToken.endIndex)
        default:
            break
        }

        guard let endingToken = lexer.nextUntil(in: [.newline, .tab, .space, .lowercaseLetter, .uppercaseLetter, .underscore, .digit]) else {
            return nil
        }

        return ExampleToken(kind: .symbol, range: token.startIndex..<endingToken.endIndex)
    }
}

typealias ExampleTokenLexer = LookAheadSequence<ExampleTokenSequence>
```

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me on [mastodon](https://mastodon.social/@mattiem).

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/Flexer/actions
[build status badge]: https://github.com/ChimeHQ/Flexer/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/Flexer
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FFlexer%2Fbadge%3Ftype%3Dplatforms
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
[discord]: https://discord.gg/esFpX6sErJ
