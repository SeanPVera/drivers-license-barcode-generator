import Foundation

class DCD: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DCD\(DataElementFormatter.formatOptionalString(data, length: 12))"
    }
}
