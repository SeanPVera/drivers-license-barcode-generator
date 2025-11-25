import Foundation

class DCF: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DCF\(DataElementFormatter.formatAlphanumeric(data, length: 25))"
    }
}
