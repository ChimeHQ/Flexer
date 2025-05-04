import XCTest

import Flexer

final class BasicTextCharacterLexerTests: XCTestCase {
    func testPeekTwiceReturnsSameValue() {
        let string = "\t"
        var lexer = BasicTextCharacterLexer(string: string)

        let token = BasicTextCharacter(kind: .tab, range: NSRange(0 ..< 1), in: string)

        XCTAssertEqual(lexer.peek(), token)
        XCTAssertEqual(lexer.peek(), token)
    }

    func testNextReturnsDifferentValue() {
        let string = "\t"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertNotNil(lexer.peek())
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .tab, range: NSRange(0 ..< 1), in: string))
        XCTAssertNil(lexer.peek())
    }

    func testPeekFurtherAndThenCloser() {
        let string = "a1"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.peek(distance: 2), BasicTextCharacter(kind: .digit, range: NSRange(1 ..< 2), in: string))
        XCTAssertEqual(lexer.peek(distance: 1), BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(0 ..< 1), in: string))
        XCTAssertEqual(lexer.peek(distance: 2), BasicTextCharacter(kind: .digit, range: NSRange(1 ..< 2), in: string))
    }
	
	func testNewlineSequences() {
		let string = "\n \r \r\n"
		var lexer = BasicTextCharacterLexer(string: string)

		XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .newline, range: NSRange(0..<1), in: string))
		XCTAssertNotNil(lexer.next())
		XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .newline, range: NSRange(2..<3), in: string))
		XCTAssertNotNil(lexer.next())
		XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .newline, range: NSRange(4..<6), in: string))
		XCTAssertNil(lexer.next())
	}
}

extension BasicTextCharacterLexerTests {
    func testPeekNextPerformance() {
        var string = ""

        for _ in 0 ..< 10000 {
            string += "abc 123 ;[];^^%\n"
        }

        measure {
            var lexer = BasicTextCharacterLexer(string: string)

            while lexer.peek() != nil {
                _ = lexer.next()
            }
        }
    }
}

extension BasicTextCharacterLexerTests {
    func testSingleLowercaseCharacter() {
        let string = "a"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(0 ..< 1), in: string))
        XCTAssertNil(lexer.next())
    }

    func testMultiCharacterUppercaseRun() {
        let string = "ABC"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(0 ..< 1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(1 ..< 2), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .uppercaseLetter, range: NSRange(2 ..< 3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testDigitRun() {
        let string = "123"
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(0 ..< 1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(1 ..< 2), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .digit, range: NSRange(2 ..< 3), in: string))
        XCTAssertNil(lexer.next())
    }

    func testNextUntilWithNoMatch() {
        let string = " ab "
        var lexer = BasicTextCharacterLexer(string: string)

        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .space, range: NSRange(0 ..< 1), in: string))
        XCTAssertEqual(lexer.next(), BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(1 ..< 2), in: string))

        // The lexer is spooled to the "a" position.
        let bToken = lexer.nextUntil(notIn: [.lowercaseLetter])
        // So the return token must be the last one matching e.g. "b".
        XCTAssertEqual(bToken, BasicTextCharacter(kind: .lowercaseLetter, range: NSRange(2 ..< 3), in: string))

        // The lexer is already spooled to the "b" position.
        // next() would be " ".
        let token = lexer.nextUntil(notIn: [.lowercaseLetter])

        // But our stop condition is notIn: [.lowercaseLetter].
        // So we need to immediately stop.
        XCTAssertNil(token)
    }
}
