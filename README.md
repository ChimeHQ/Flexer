[![Github CI](https://github.com/ChimeHQ/Flexer/workflows/CI/badge.svg)](https://github.com/ChimeHQ/Flexer/actions)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# Flexer

Flexer is a small library for building lexers in Swift. It is compatible with all Apple platforms.

- API tailored for hand-written parsing
- Fully Swift `String`-compatible
- Based around `Sequence` and `IteratorProtocol` procotols

It turns out that Swift's `Sequence` and `Iterator` concepts work pretty well for processing tokens. They make for a familiar API that also offers a surprsing amount of power. Flexer builds on these concepts with some new protocols that are made specifically for lexing, but are generally applicable to all `Sequence` types.

## Integration

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Flexer.git")
]
```

### Carthage

```
github "ChimeHQ/Flexer"
```

## Look-Ahead

Core to lexing is the ability to look ahead at future tokens without advancing. Flexer implements look-ahead with a protocol called `LookAheadIteratorProtocol`. The whole implemenation is inspired by the `lazy` property of `Sequence`, and works very similarly.

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

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.