import Foundation

class DCB: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DCB\(DataElementFormatter.formatOptionalString(data, length: 12))"
    }
}
