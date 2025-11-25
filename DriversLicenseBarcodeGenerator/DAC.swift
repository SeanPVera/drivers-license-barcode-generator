import Foundation

class DAC: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAC\(DataElementFormatter.formatName(data, length: 40))"
    }
}
