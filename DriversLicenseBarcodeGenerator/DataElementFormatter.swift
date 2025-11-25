import Foundation

class DataElementFormatter {
    private static let cachedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMddyyyy"
        return formatter
    }()

    private static let whitespaceRegex = try! NSRegularExpression(pattern: "\\s+", options: [])

    private static let defaultAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '-.,&/")
    private static let nameAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '-.")
    private static let cityAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '-.")
    private static let addressAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '#&.,-/ ")
    private static let alphanumericAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

    static func formatString(_ string: String, length: Int) -> String {
        return String(string.prefix(length))
    }

    static func formatName(_ string: String, length: Int) -> String {
        return sanitize(string, allowedCharacters: nameAllowedCharacters, length: length)
    }

    static func sanitizedName(_ string: String) -> String {
        return sanitizeRaw(string, allowedCharacters: nameAllowedCharacters, collapseWhitespace: true)
    }

    static func formatStreet(_ string: String, length: Int) -> String {
        return sanitize(string, allowedCharacters: addressAllowedCharacters, length: length)
    }

    static func formatCity(_ string: String, length: Int) -> String {
        return sanitize(string, allowedCharacters: cityAllowedCharacters, length: length)
    }

    static func formatAlphanumeric(_ string: String, length: Int) -> String {
        return sanitize(string, allowedCharacters: alphanumericAllowedCharacters, length: length, collapseWhitespace: false)
    }

    static func formatOptionalString(_ string: String, length: Int) -> String {
        return sanitize(string, allowedCharacters: defaultAllowedCharacters, length: length)
    }

    static func formatDate(date: Date) -> String {
        return cachedDateFormatter.string(from: date)
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

    static func formatHeight(inches: Int, usesMetric: Bool) -> String {
        guard inches > 0 else { return "" }

        if usesMetric {
            let centimeters = Int((Double(inches) * 2.54).rounded())
            return String(format: "%03d CM", centimeters)
        }

        return String(format: "%03d IN", inches)
    }

    private static func sanitize(_ string: String, allowedCharacters: CharacterSet, length: Int, collapseWhitespace: Bool = true) -> String {
        let raw = sanitizeRaw(string, allowedCharacters: allowedCharacters, collapseWhitespace: collapseWhitespace)
        let view = String.UnicodeScalarView(raw.unicodeScalars)
        return String(view.prefix(length))
    }

    private static func sanitizeRaw(_ string: String, allowedCharacters: CharacterSet, collapseWhitespace: Bool) -> String {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        let folded = trimmed.folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: Locale(identifier: "en_US_POSIX"))
        let uppercased = folded.uppercased()

        let normalized: String
        if collapseWhitespace {
            let range = NSRange(location: 0, length: (uppercased as NSString).length)
            normalized = whitespaceRegex.stringByReplacingMatches(in: uppercased, options: [], range: range, withTemplate: " ")
        } else {
            normalized = uppercased
        }

        let filteredScalars = normalized.unicodeScalars.filter { allowedCharacters.contains($0) }
        return String(String.UnicodeScalarView(filteredScalars))
    }
}
