import XCTest
@testable import DriversLicenseBarcodeGenerator

final class BarcodeTests: XCTestCase {
    private let configuration = Barcode.Configuration(
        issuerIdentificationNumber: "636000",
        aamvaVersionNumber: "08",
        jurisdictionVersionNumber: "00",
        subfileType: .DL
    )

    func testDescriptionBeginsWithAnsiHeader() {
        let barcode = makeSampleBarcode()
        let description = barcode.description

        XCTAssertTrue(description.hasPrefix("@\n\u{1E}\rANSI 6360000800"))
    }

    func testDescriptorEncodesOffsetAndLength() {
        let barcode = makeSampleBarcode()
        let description = barcode.description
        let header = Header(
            issuerIdentificationNumber: configuration.issuerIdentificationNumber,
            AAMVAVersionNumber: configuration.aamvaVersionNumber,
            jurisdictionVersionNumber: configuration.jurisdictionVersionNumber,
            numberOfEntries: 1
        ).description

        let headerLength = header.utf8.count
        let descriptorStart = description.index(description.startIndex, offsetBy: headerLength)
        let descriptorEnd = description.index(descriptorStart, offsetBy: 10)
        let descriptor = String(description[descriptorStart..<descriptorEnd])

        XCTAssertEqual(descriptor.prefix(2), "DL")

        let offsetString = descriptor.dropFirst(2).prefix(4)
        let lengthString = descriptor.dropFirst(6).prefix(4)
        let expectedOffset = String(format: "%04d", headerLength + 10)
        XCTAssertEqual(offsetString, expectedOffset)

        let dataPortion = String(description[descriptorEnd...])
        XCTAssertEqual(lengthString, String(format: "%04d", dataPortion.utf8.count))
        XCTAssertTrue(dataPortion.hasPrefix("DLDAQSS430403"))
    }

    func testEncodedDataIsASCII() {
        let barcode = makeSampleBarcode()
        XCTAssertNoThrow(try barcode.encodedData())
    }

    private func makeSampleBarcode() -> Barcode {
        let dataElements: [DataElementFormatable] = [
            DAQ("SS430403"),
            DCS("Decot"),
            DAC("Kyle"),
            DAD(["Brandon"]),
            DBD(Self.buildDate(year: 2015, month: 10, day: 3)),
            DBB(Self.buildDate(year: 1986, month: 9, day: 14)),
            DBA(Self.buildDate(year: 2019, month: 9, day: 14)),
            DBC(.Male),
            DAY(.Hazel),
            DAU(70),
            DAG("1437 Chesapeake Ave"),
            DAI("Columbus"),
            DAJ("OH"),
            DAK("43212"),
            DCF("2509UN6813300000"),
            DCG(.US),
            DDE(.No),
            DDF(.No),
            DDG(.No),
            DCA("D"),
            DCB("A"),
            DCD("NONE")
        ]

        return Barcode(dataElements: dataElements, configuration: configuration)
    }

    private static func buildDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return Calendar(identifier: .gregorian).date(from: dateComponents)!
    }
}
