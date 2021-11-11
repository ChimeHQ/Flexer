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
}
