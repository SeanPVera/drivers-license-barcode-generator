import Foundation

struct HeightParser {
    static func inches(from input: String) -> Int? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let lowercased = trimmed.lowercased()

        if let centimeters = parseCentimeters(from: lowercased) {
            return Int((centimeters / 2.54).rounded())
        }

        if let feetAndInches = parseFeetAndInches(from: lowercased) {
            return feetAndInches
        }

        if let inches = parseExplicitInches(from: lowercased) {
            return inches
        }

        if let ambiguous = parseAmbiguousPair(from: lowercased) {
            return ambiguous
        }

        if let numericCentimeters = Double(trimmed), numericCentimeters >= 100 {
            return Int((numericCentimeters / 2.54).rounded())
        }

        if let numericInches = Int(trimmed) {
            return numericInches
        }

        return nil
    }

    private static func parseCentimeters(from input: String) -> Double? {
        guard input.contains("cm") || input.contains("centimeter") else {
            return nil
        }

        let cleaned = input
            .replacingOccurrences(of: "centimeters", with: "cm")
            .replacingOccurrences(of: "centimeter", with: "cm")

        let scanner = Scanner(string: cleaned)
        scanner.charactersToBeSkipped = CharacterSet.whitespacesAndNewlines
        scanner.locale = Locale(identifier: "en_US_POSIX")

        var value: Double = 0
        guard scanner.scanDouble(&value) else {
            return nil
        }

        return value
    }

    private static func parseFeetAndInches(from input: String) -> Int? {
        let normalized = input
            .replacingOccurrences(of: "feet", with: "ft")
            .replacingOccurrences(of: "foot", with: "ft")
            .replacingOccurrences(of: "\"", with: " in")
            .replacingOccurrences(of: "\u{2033}", with: " in")
            .replacingOccurrences(of: "\u{2032}", with: " ft")
            .replacingOccurrences(of: "'", with: " ft ")
            .replacingOccurrences(of: "-", with: " ")

        let numberStrings = extractNumbers(from: normalized)
        guard !numberStrings.isEmpty else { return nil }

        var feet = 0
        var inches = 0

        if normalized.contains("ft") {
            feet = Int(numberStrings.first ?? "0") ?? 0
            if numberStrings.count >= 2 {
                inches = Int(numberStrings[1]) ?? 0
            }
            return feet * 12 + inches
        }

        if normalized.contains("'" ) {
            feet = Int(numberStrings.first ?? "0") ?? 0
            if numberStrings.count >= 2 {
                inches = Int(numberStrings[1]) ?? 0
            }
            return feet * 12 + inches
        }

        return nil
    }

    private static func parseExplicitInches(from input: String) -> Int? {
        guard input.contains("in") || input.contains("inch") else {
            return nil
        }

        let numberStrings = extractNumbers(from: input)
        guard let inchesString = numberStrings.first, let inches = Int(inchesString) else {
            return nil
        }

        return inches
    }

    private static func parseAmbiguousPair(from input: String) -> Int? {
        let numberStrings = extractNumbers(from: input)
        guard numberStrings.count == 2,
              let first = Int(numberStrings[0]),
              let second = Int(numberStrings[1]),
              first < 10 else {
            return nil
        }

        return first * 12 + second
    }

    private static func extractNumbers(from input: String) -> [String] {
        let pattern = "\\d+(?:\\.\\d+)?"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }

        let range = NSRange(location: 0, length: (input as NSString).length)
        let matches = regex.matches(in: input, options: [], range: range)

        return matches.compactMap { match -> String? in
            guard let range = Range(match.range, in: input) else { return nil }
            return String(input[range])
        }
    }
}
