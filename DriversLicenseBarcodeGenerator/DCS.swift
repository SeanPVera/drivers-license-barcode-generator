import Foundation

class DCS: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DCS\(DataElementFormatter.formatName(data, length: 40))"
    }
}
