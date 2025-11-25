import Foundation

enum SubfileType: String, CaseIterable {
    case DL = "DL"
    case ID = "ID"
}

class Barcode {
    struct Configuration {
        let issuerIdentificationNumber: String
        let aamvaVersionNumber: String
        let jurisdictionVersionNumber: String
        let subfileType: SubfileType

        init(issuerIdentificationNumber: String, aamvaVersionNumber: String, jurisdictionVersionNumber: String, subfileType: SubfileType) {
            self.issuerIdentificationNumber = issuerIdentificationNumber
            self.aamvaVersionNumber = aamvaVersionNumber
            self.jurisdictionVersionNumber = jurisdictionVersionNumber
            self.subfileType = subfileType
        }
    }

    enum EncodingError: Error {
        case nonASCII
    }

    static let complianceIndicator = "\u{40}"
    static let dataElementSeparator = "\u{0A}"
    static let recordSeparator = "\u{1E}"
    static let segmentSeparator = "\u{0D}"
    static let fileType = "ANSI "

    private static let descriptorLength = 10

    let dataElements: [DataElementFormatable]
    let configuration: Configuration

    init(dataElements: [DataElementFormatable], configuration: Configuration) {
        self.dataElements = dataElements
        self.configuration = configuration
    }

    func encodedData() throws -> Data {
        guard let data = description.data(using: .ascii) else {
            throw EncodingError.nonASCII
        }

        return data
    }
}

extension Barcode: CustomStringConvertible {
    var description: String {
        let formattedElements = dataElements.map { $0.format() }
        let payload = formattedElements.joined(separator: Barcode.dataElementSeparator)
        let subfileData = configuration.subfileType.rawValue + payload

        let header = Header(
            issuerIdentificationNumber: configuration.issuerIdentificationNumber,
            AAMVAVersionNumber: configuration.aamvaVersionNumber,
            jurisdictionVersionNumber: configuration.jurisdictionVersionNumber,
            numberOfEntries: 1
        ).description

        let headerLength = header.utf8.count
        let descriptorLength = Barcode.descriptorLength
        let subfileOffset = headerLength + descriptorLength
        let subfileDescriptor = SubfileDescriptor(type: configuration.subfileType, offset: subfileOffset, length: subfileData.utf8.count)

        return header + subfileDescriptor.encoded() + subfileData
    }
}

private struct SubfileDescriptor {
    let type: SubfileType
    let offset: Int
    let length: Int

    func encoded() -> String {
        let offsetString = String(format: "%04d", offset)
        let lengthString = String(format: "%04d", length)
        return "\(type.rawValue)\(offsetString)\(lengthString)"
    }
}


