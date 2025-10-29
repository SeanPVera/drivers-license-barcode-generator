import Foundation

class DAK: DataElement<String>, DataElementFormatable {
    func format() -> String {
        let normalized = DataElementFormatter.formatPostalCode(postalCode: data)
        return "DAK\(DataElementFormatter.formatString(normalized, length: 11))"
    }
}
