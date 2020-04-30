[![Github CI](https://github.com/ChimeHQ/Flexer/workflows/CI/badge.svg)](https://github.com/ChimeHQ/Flexer/actions)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

# Flexer

Flexer is a small library for building lexers in Swift.

- API tailored for hand-written parsing
- Fully Swift `String`-compatible
- Based around `Sequence` and `IteratorProtocol` procotols

It turns out that Swift's `Sequence` and `Iterator` concepts work pretty well for processing tokens. They make for a familiar API that also offers a surprsing amount of power. Flexer builds on these concepts with some new protocols that are made specifically for lexing, but are generally applicable to all `Sequence` types.

## Look-Ahead

Core to lexing is the ability to look ahead at future tokens without advancing. Flexer implements look-ahead with a protocol called `LookAheadIteratorProtocol`. The whole implemenation is inspired by the `lazy` property of `Sequence`, and works very similarly.

```swift
let lookAheadSequence = anySequence.lookAhead


```

The main work of building your lexer is then defining a Sequence type of tokens. All of lexing facilities you might need can then be exposed with a simple `typealias`.

```swift
typealias MyLexer = LookAheadSequence<MyTokenSequence>
  
let tokenSequence = MyLexer(string: myString)

let nextToken = lexer.next()
let futureToken = lexer.peek()
let tabToken = lexer.nextUntil({ $0.kind == .tab })
```

## Token Sequences

Your custom token sequence can be built by creating a struct that conforms to `Sequence`. To make this easier, Flexer includes a type that can be used as a foundation for creating more complex token streams, called `BasicTextCharacterSequence`. It is a sequence of `BasicTextCharacter` elements. It breaks up a string into commonly-needed tokens, catagorized by kind and range within the source string. This approach uses the `Token` type, which stores a kind and a range within the source string.

It is usually much easier to build up more complex lexing functionality with the convenience of Swift switch pattern matching, instead of having to worry about the underlying characters and ranges themselves.

Flexer also includes a generic `Token` struct, that you might find handy for defining your own custom token types. `BasicTextCharacter` is implemented in terms of `Token`.