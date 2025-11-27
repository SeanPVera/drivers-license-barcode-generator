import Foundation

class DAH: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAH\(DataElementFormatter.formatStreet(data, length: 35))"
    }
}
