import Foundation

enum SubfileType: String {
    case DL = "DL"
    case ID = "ID"
}

class Barcode {
    static let complianceIndicator = "\u{40}"
    static let dataElementSeparator = "\u{0A}"
    static let recordSeparator = "\u{1E}"
    static let segmentSeparator = "\u{0D}"
    static let fileType = "ANSI "
    
    let dataElements: [Any]
    let issuerIdentificationNumber: String
    let AAMVAVersionNumber: String
    let jurisdictionVersionNumber: String

    var data: Data {
        return description.data(using: String.Encoding.ascii)!
    }

    init(dataElements: [Any], issuerIdentificationNumber: String, AAMVAVersionNumber: String, jurisdictionVersionNumber: String) {
        self.issuerIdentificationNumber = issuerIdentificationNumber
        self.dataElements = dataElements
        self.AAMVAVersionNumber = AAMVAVersionNumber
        self.jurisdictionVersionNumber = jurisdictionVersionNumber
    }
}

extension Barcode: CustomStringConvertible {
    var description: String {
        var allElements = dataElements

        if let dcs = dataElements.first(where: { $0 is DCS }) as? DCS {
            allElements.append(DDE(dcs.data.count > 40 ? .Yes : .No))
        }

        if let dac = dataElements.first(where: { $0 is DAC }) as? DAC {
            allElements.append(DDF(dac.data.count > 40 ? .Yes : .No))
        }

        if let dag = dataElements.first(where: { $0 is DAG }) as? DAG {
            allElements.append(DDG(dag.data.count > 40 ? .Yes : .No))
        }

        let header = Header(issuerIdentificationNumber: issuerIdentificationNumber, AAMVAVersionNumber: AAMVAVersionNumber, jurisdictionVersionNumber: jurisdictionVersionNumber, numberOfEntries: "\(allElements.count)").description
        let formattedDataElemented = allElements.map { ($0 as! DataElementFormatable).format() }
        let joined = formattedDataElemented.joined(separator: Barcode.dataElementSeparator)

        return "\(header)\(joined)"
    }
}


