import XCTest
@testable import DriversLicenseBarcodeGenerator

final class DataElementFormatterTests: XCTestCase {
    private let date = buildDate(year: 1986, month: 9, day: 14)

    func testFormatNameStripsDiacriticsAndUppercases() {
        let formatted = DataElementFormatter.formatName("Élodie-Marie", length: 40)
        XCTAssertEqual(formatted, "ELODIE-MARIE")
    }

    func testFormatStreetPreservesUnitSymbols() {
        let formatted = DataElementFormatter.formatStreet("123 Main St. #5B", length: 35)
        XCTAssertEqual(formatted, "123 MAIN ST. #5B")
    }

    func testFormatAlphanumericTruncates() {
        let formatted = DataElementFormatter.formatAlphanumeric("ABC1234567890", length: 10)
        XCTAssertEqual(formatted, "ABC1234567")
    }

    func testFormatPostalCodePadsNumericZip() {
        XCTAssertEqual(DataElementFormatter.formatPostalCode(postalCode: "43212"), "432120000")
    }

    func testFormatPostalCodeStripsDelimiters() {
        XCTAssertEqual(DataElementFormatter.formatPostalCode(postalCode: "43212-1234"), "432121234")
    }

    func testFormatPostalCodeHandlesAlphanumericValues() {
        XCTAssertEqual(DataElementFormatter.formatPostalCode(postalCode: "K1A 0B1"), "K1A0B1")
    }

    func testFormatDate() {
        XCTAssertEqual(DataElementFormatter.formatDate(date: date), "09141986")
    }

    func testFormatHeightInInches() {
        XCTAssertEqual(DataElementFormatter.formatHeight(inches: 70, usesMetric: false), "070 IN")
    }

    func testFormatHeightInCentimeters() {
        XCTAssertEqual(DataElementFormatter.formatHeight(inches: 70, usesMetric: true), "178 CM")
    }

    private func buildDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Calendar(identifier: .gregorian).date(from: components)!
    }
}
