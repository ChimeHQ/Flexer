import XCTest
@testable import Flexer

final class LookAheadSequenceReferenceTests: XCTestCase {
    func testMutatingMethods() {
        let string = "a1"
        let lexer = BasicTextCharacterLexer(string: string).reference

        XCTAssertNotNil(lexer.next())
        XCTAssertNotNil(lexer.next())
        XCTAssertNil(lexer.next())
    }

    func testGetSubstsring() throws {
        let string = "a1"
        let lexer = BasicTextCharacterLexer(string: string).reference
        let token = try XCTUnwrap(lexer.peek())

        XCTAssertEqual(lexer.substring(for: token), "a")
    }
}
