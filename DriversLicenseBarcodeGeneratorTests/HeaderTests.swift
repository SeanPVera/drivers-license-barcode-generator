import XCTest

class HeaderTests: XCTestCase {
    func testDescriptionIncludesPaddedEntryCount() {
        let expected = "@\n\u{1E}\rANSI 123456080101"
        let header = Header(issuerIdentificationNumber: "123456", AAMVAVersionNumber: "08", jurisdictionVersionNumber: "01", numberOfEntries: 1)

        XCTAssertEqual(header.description, expected)
    }
}
