import Foundation

class DAD: DataElement<[String]>, DataElementFormatable {
    func format() -> String {
        let joined = data.joined(separator: " ")
        return "DAD\(DataElementFormatter.formatName(joined, length: 40))"
    }
}
