import Foundation

class DAU: DataElement<Int>, DataElementFormatable {
    func format() -> String {
        return "DAU\(DataElementFormatter.formatHeight(inches: data, usesMetric: false))"
    }
}
