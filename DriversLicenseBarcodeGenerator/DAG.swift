import Foundation

class DAG: DataElement<String>, DataElementFormatable {
    func format() -> String {
        return "DAG\(DataElementFormatter.formatStreet(data, length: 35))"
    }
}
