import Foundation

class DAQ: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAQ\(DataElementFormatter.formatAlphanumeric(data, length: 25))"
    }
}
