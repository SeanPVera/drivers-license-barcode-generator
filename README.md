# Driver's License Barcode Generator (Web)

A modern, free, browser-based tool for producing AAMVA-compliant PDF417 barcodes. Everything runs client-side, so your data never leaves your device. Enter credential details, generate the barcode, and download a high-resolution PNG in seconds.

## Features

- **AAMVA-spec payload assembly** – Builds the ANSI header, DL/ID subfile descriptor, and core data elements with correct separators and byte counts.
- **Smart sanitization** – Normalizes names, addresses, and identifiers to the character and length limits defined by the current AAMVA standard.
- **Jurisdiction-aware defaults** – Includes every U.S. state with automatic U.S. country locking for AAMVA DL/ID payloads.
- **High-resolution rendering** – Uses BWIP-JS to render PDF417 barcodes at configurable scales with generous quiet zones for scanning reliability.
- **Stateful UX** – Persists the most recent form entries locally (in `localStorage`) so frequent users can resume where they left off.

## Getting Started

1. Clone this repository.
2. Open `index.html` in any modern browser **or** serve the files locally (recommended for localStorage support):

   ```bash
   # Python 3
   python -m http.server
   # Then visit http://localhost:8000
   ```

3. Complete the form, press **Generate Barcode**, and use the preview panel to download the PNG or copy the raw payload.

## Field Notes

- The issuer identification number (IIN), AAMVA version, and jurisdiction version must be numeric and will be validated before a barcode is produced.
- Height can be entered in inches (`70 in`), feet and inches (`5'11"`), or centimeters (`180 cm`). Choose whether the barcode should encode inches or centimeters.
- The generator strips unsupported characters (such as emojis or accents) and truncates values to the maximum allowed length while tracking name truncation flags (DDE/DDF/DDG).
- Postal codes are padded to nine digits for numeric ZIP codes or trimmed to 11 characters for alphanumeric codes.

## Technology Stack

- **HTML/CSS** for a responsive, accessible UI.
- **Modern JavaScript (ES2022)** for data formatting, validation, local persistence, and barcode assembly.
- **[BWIP-JS](https://github.com/metafloor/bwip-js)** (via CDN) for high-quality PDF417 rendering directly in the browser.

## Contributing

Issues and pull requests are welcome! A few ideas for future enhancements:

- Support importing/exporting named profiles for frequent issuers.
- Add automated tests for the formatter and payload assembly logic (e.g., using Jest).
- Offer a CLI or serverless endpoint for automated barcode generation workflows.

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.
