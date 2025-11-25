import Foundation

class DCG: DataElement<DataElementCountryIdentificationCode>, DataElementFormatable {
    func format() -> String {
        return "DCG\(DataElementFormatter.formatAlphanumeric(data.rawValue, length: 3))"
    }
}
