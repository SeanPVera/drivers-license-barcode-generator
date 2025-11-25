import Foundation

class DCA: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DCA\(DataElementFormatter.formatOptionalString(data, length: 12))"
    }
}
