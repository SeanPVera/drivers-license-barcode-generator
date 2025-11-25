import Foundation

class DAJ: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAJ\(DataElementFormatter.formatAlphanumeric(data, length: 3))"
    }
}
