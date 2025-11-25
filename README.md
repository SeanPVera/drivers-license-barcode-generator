# Drivers License Barcode Generator

Generate production-quality PDF417 barcodes that comply with the current AAMVA DL/ID Card Design Standard. The app is free, open source, and tuned for rapid data entry so you can produce high-resolution driver's-license barcodes in seconds.

## Highlights

- **Standards compliant** – Emits DL/ID subfiles using the 2020 (version 08) AAMVA specification, complete with configurable issuer ID and jurisdiction version numbers.
- **Data validation and sanitisation** – Inputs are uppercased, diacritics are removed, and lengths are capped to the official field sizes so every payload is legal ASCII.
- **Full PDF417 control** – Pick the credential type (DL or ID), tune the barcode scale, and export a crisp PNG for printing or archival use.
- **Expanded locale support** – Capture a second address line, choose from an expanded ISO country list, and automatically align country/state selections.
- **Stateful experience** – All fields (including scale, country, and metadata) persist between launches for a faster workflow.

## Getting Started

1. Open `DriversLicenseBarcodeGenerator.xcodeproj` in Xcode 14 or newer.
2. Select the `DriversLicenseBarcodeGenerator` scheme and build/run the macOS app.
3. Enter the credential details, adjust the AAMVA metadata (issuer ID, version numbers, and credential type), and move the **Barcode Scale** slider to the desired resolution.
4. Click **Generate** to render the barcode. Use **Save Image** to export a high-resolution PNG or **Copy Data** to place the raw payload on the clipboard.

## Testing

Unit tests cover the formatter, barcode assembly, and height parsing logic. Run them from Xcode or via the command line:

```bash
xcodebuild test -project DriversLicenseBarcodeGenerator.xcodeproj -scheme DriversLicenseBarcodeGeneratorTests
```

## Contributing

Issues and pull requests are welcome. If you implement new AAMVA data elements, favour the existing `DataElementFormatter` helpers to keep sanitisation consistent across fields.
