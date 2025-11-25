import Foundation

class DAI: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAI\(DataElementFormatter.formatCity(data, length: 30))"
    }
}
