import XCTest
@testable import DriversLicenseBarcodeGenerator

class DataElementFormatterTests: XCTestCase {
    let date = buildDate(year: 1986, month: 9, day: 14)!

    func testFormatString() {
        XCTAssertEqual(DataElementFormatter.formatString("KYLEDECOT", length: 5), "KYLED")
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

    fileprivate static func buildDate(year: Int, month: Int, day: Int) -> Date! {
        let calendar = NSCalendar.current

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return calendar.date(from: dateComponents as DateComponents)!
    }
}
