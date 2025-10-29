import Foundation

class DataElementFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMddyyyy"

        return formatter
    }

    static func formatString(_ string: String, length: Int) -> String {
        return String(string.prefix(length))
    }

    static func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    static func formatPostalCode(postalCode: String) -> String {
        let trimmed = postalCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !trimmed.isEmpty else { return "" }

        let alphanumerics = trimmed.filter { $0.isLetter || $0.isNumber }
        guard !alphanumerics.isEmpty else { return "" }

        if alphanumerics.allSatisfy({ $0.isNumber }) {
            return alphanumerics.padding(toLength: 9, withPad: "0", startingAt: 0)
        }

        return String(alphanumerics.prefix(11))
    }
}
