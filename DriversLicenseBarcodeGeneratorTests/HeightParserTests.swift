import XCTest
@testable import DriversLicenseBarcodeGenerator

class HeightParserTests: XCTestCase {
    func testParsesInches() {
        XCTAssertEqual(HeightParser.inches(from: "72"), 72)
        XCTAssertEqual(HeightParser.inches(from: "72 in"), 72)
        XCTAssertEqual(HeightParser.inches(from: "72in"), 72)
    }

    func testParsesFeetAndInches() {
        XCTAssertEqual(HeightParser.inches(from: "6'0\""), 72)
        XCTAssertEqual(HeightParser.inches(from: "5 ft 11 in"), 71)
        XCTAssertEqual(HeightParser.inches(from: "5-11"), 71)
    }

    func testParsesCentimeters() {
        XCTAssertEqual(HeightParser.inches(from: "180 cm"), 71)
        XCTAssertEqual(HeightParser.inches(from: "170"), 67)
    }

    func testReturnsNilForInvalidInput() {
        XCTAssertNil(HeightParser.inches(from: ""))
        XCTAssertNil(HeightParser.inches(from: "abc"))
    }
}
