import Cocoa
import CoreImage

class ViewController: NSViewController {
    @IBOutlet var imageView: NSImageView!

    @IBOutlet var firstNameTextField: NSTextField!
    @IBOutlet var middleNameTextField: NSTextField!
    @IBOutlet var lastNameTextField: NSTextField!

    @IBOutlet var address1TextField: NSTextField!
    @IBOutlet var address2TextField: NSTextField!
    @IBOutlet var cityTextField: NSTextField!
    @IBOutlet var zipTextField: NSTextField!
    @IBOutlet var statePopupButton: NSPopUpButton!
    @IBOutlet var countryPopupButton: NSPopUpButton!
    @IBOutlet var stateFilterSearchField: NSSearchField!

    @IBOutlet var issuerIdentificationNumberTextField: NSTextField!
    @IBOutlet var aamvaVersionNumberTextField: NSTextField!
    @IBOutlet var jurisdictionVersionNumberTextField: NSTextField!
    @IBOutlet var subfileTypePopUpButton: NSPopUpButton!

    @IBOutlet var barcodeScaleSlider: NSSlider!
    @IBOutlet var barcodeScaleLabel: NSTextField!

    @IBOutlet var expirationDatePicker: NSDatePicker!
    @IBOutlet var issueDatePicker: NSDatePicker!
    @IBOutlet var dateOfBirthDatePicker: NSDatePicker!
    @IBOutlet var sexPopupButton: NSPopUpButton!
    @IBOutlet var eyeColor: NSPopUpButton!
    @IBOutlet var customerIDNumberTextField: NSTextField!

    @IBOutlet var jurisdictionSpecificVehicleClassTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificEndorsementCodesTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificRestrictionCodesTextField: NSTextField!
    @IBOutlet var physicalDescriptionHeightTextField: NSTextField!
    @IBOutlet var documentDiscriminatorTextField: NSTextField!

    private var documentDiscriminatorValue = ViewController.makeDocumentDiscriminator()
    private var filteredJurisdictionOptions: [JurisdictionOption] = []
    private var lastGeneratedBarcode: Barcode?
    private var lastRenderedBarcode: RenderedBarcode?
    private let defaults = UserDefaults.standard
    private var textFieldDefaultsMap: [NSTextField: String] = [:]

    private enum BarcodeRenderingError: Error {
        case generatorUnavailable
        case outputFailure
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        filteredJurisdictionOptions = ViewController.jurisdictionOptions.sorted { $0.name < $1.name }
        configureTextFieldPersistence()
        configureSearchField()
        configurePopUpMenus()
        updateDocumentDiscriminatorDisplay()
        restorePersistedSelections()

        barcodeScaleSlider.target = self
        barcodeScaleSlider.action = #selector(barcodeScaleDidChange(_:))
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private var jurisdictionSpecificEndorsementCodes: String {
        return trimmedValue(from: jurisdictionSpecificEndorsementCodesTextField)
    }

    private var jurisdictionSpecificRestrictionCodes: String {
        return trimmedValue(from: jurisdictionSpecificRestrictionCodesTextField)
    }

    private var jurisdictionSpecificVehicleClass: String {
        return trimmedValue(from: jurisdictionSpecificVehicleClassTextField)
    }

    private var documentExpirationDate: Date {
        return expirationDatePicker.dateValue
    }

    private var customerFamilyName: String {
        return trimmedValue(from: lastNameTextField)
    }

    private var customerFirstName: String {
        return trimmedValue(from: firstNameTextField)
    }

    private var customerMiddleNames: [String] {
        return middleNameComponents
    }

    private var sanitizedFamilyName: String {
        return DataElementFormatter.sanitizedName(customerFamilyName)
    }

    private var sanitizedFirstName: String {
        return DataElementFormatter.sanitizedName(customerFirstName)
    }

    private var sanitizedMiddleNameBlock: String {
        return DataElementFormatter.sanitizedName(joinedMiddleNames)
    }

    private var documentIssueDate: Date {
        return issueDatePicker.dateValue
    }

    private var dateOfBirth: Date {
        return dateOfBirthDatePicker.dateValue
    }

    private var physicalDescriptionSex: DataElementGender {
        if let selectedRaw = sexPopupButton.selectedItem?.representedObject as? NSNumber,
           let gender = DataElementGender(rawValue: selectedRaw.intValue) {
            return gender
        }

        return .NotSpecified
    }

    private var physicalDescriptionEyeColor: DataElementEyeColor {
        if let raw = eyeColor.selectedItem?.representedObject as? String,
           let color = DataElementEyeColor(rawValue: raw) {
            return color
        }

        return .Unknown
    }

    private var physicalDescriptionHeight: Int {
        let rawValue = physicalDescriptionHeightTextField.stringValue
        guard let height = HeightParser.inches(from: rawValue) else {
            return 0
        }

        return height
    }

    private var addressStreet1: String {
        return trimmedValue(from: address1TextField)
    }

    private var addressStreet2: String {
        return trimmedValue(from: address2TextField)
    }

    private var addressCity: String {
        return trimmedValue(from: cityTextField)
    }

    private var addressJurisdictionCode: String {
        if let metadata = selectedStateMetadata {
            return metadata.code
        }

        return ""
    }

    private var addressPostalCode: String {
        return trimmedValue(from: zipTextField)
    }

    private var customerIDNumber: String {
        return trimmedValue(from: customerIDNumberTextField)
    }

    private var issuerIdentificationNumber: String {
        return trimmedValue(from: issuerIdentificationNumberTextField)
    }

    private var aamvaVersionNumber: String {
        return trimmedValue(from: aamvaVersionNumberTextField)
    }

    private var jurisdictionVersionNumber: String {
        return trimmedValue(from: jurisdictionVersionNumberTextField)
    }

    private var documentDiscriminator: String {
        let textFieldValue = trimmedValue(from: documentDiscriminatorTextField)
        let sanitized = DataElementFormatter.formatAlphanumeric(textFieldValue, length: 25)
        if sanitized.isEmpty {
            documentDiscriminatorValue = ViewController.makeDocumentDiscriminator()
            updateDocumentDiscriminatorDisplay()
            return documentDiscriminatorValue
        }

        if sanitized != documentDiscriminatorTextField.stringValue {
            documentDiscriminatorTextField.stringValue = sanitized
        }

        documentDiscriminatorValue = sanitized
        return documentDiscriminatorValue
    }

    private var countryIdentification: DataElementCountryIdentificationCode {
        if let raw = countryPopupButton.selectedItem?.representedObject as? String,
           let country = DataElementCountryIdentificationCode(rawValue: raw) {
            return country
        }

        if let metadata = selectedStateMetadata,
           let countryIdentification = DataElementCountryIdentificationCode(rawValue: metadata.countryRaw) {
            return countryIdentification
        }

        return .US
    }

    private var selectedSubfileType: SubfileType {
        if let raw = subfileTypePopUpButton.selectedItem?.representedObject as? String,
           let type = SubfileType(rawValue: raw) {
            return type
        }

        return .DL
    }

    private var barcodeScale: CGFloat {
        return CGFloat(barcodeScaleSlider.doubleValue)
    }

    private var barcodeConfiguration: Barcode.Configuration {
        return Barcode.Configuration(
            issuerIdentificationNumber: issuerIdentificationNumber,
            aamvaVersionNumber: aamvaVersionNumber,
            jurisdictionVersionNumber: jurisdictionVersionNumber,
            subfileType: selectedSubfileType
        )
    }

    private var dataElements: [DataElementFormatable] {
        var elements: [DataElementFormatable] = [
            DAQ(customerIDNumber),
            DCS(customerFamilyName),
            DAC(customerFirstName),
            DAD(customerMiddleNames),
            DBD(documentIssueDate),
            DBB(dateOfBirth),
            DBA(documentExpirationDate),
            DBC(physicalDescriptionSex),
            DAY(physicalDescriptionEyeColor),
            DAU(physicalDescriptionHeight),
            DAG(addressStreet1)
        ]

        if !addressStreet2.isEmpty {
            elements.append(DAH(addressStreet2))
        }

        elements.append(contentsOf: [
            DAI(addressCity),
            DAJ(addressJurisdictionCode),
            DAK(addressPostalCode),
            DCF(documentDiscriminator),
            DCG(countryIdentification),
            DDE(lastNameTruncation),
            DDF(firstNameTruncation),
            DDG(middleNameTruncation),
            DCA(jurisdictionSpecificVehicleClass),
            DCB(jurisdictionSpecificRestrictionCodes),
            DCD(jurisdictionSpecificEndorsementCodes),
        ])

        return elements
    }

    // MARK: - Actions

    @IBAction func generate(sender: Any) {
        clearValidationHighlights()

        let validationIssues = validateInputs()
        guard validationIssues.isEmpty else {
            NSBeep()
            applyValidationIssues(validationIssues)
            return
        }

        let barcode = Barcode(dataElements: dataElements, configuration: barcodeConfiguration)

        do {
            let rendered = try renderPDF417Barcode(from: barcode)
            imageView.image = rendered.image
            lastGeneratedBarcode = barcode
            lastRenderedBarcode = rendered
            clearValidationHighlights()
        } catch Barcode.EncodingError.nonASCII {
            imageView.image = nil
            lastRenderedBarcode = nil
            lastGeneratedBarcode = nil
            presentAlert(messageText: "Invalid Characters", informativeText: "AAMVA barcodes only support ASCII characters. Remove accented or special characters and try again.")
        } catch BarcodeRenderingError.generatorUnavailable {
            imageView.image = nil
            lastRenderedBarcode = nil
            lastGeneratedBarcode = nil
            presentAlert(messageText: "Barcode Generator Unavailable", informativeText: "macOS could not load the PDF417 generator. Verify that Core Image is available on this system and try again.")
        } catch {
            imageView.image = nil
            lastRenderedBarcode = nil
            lastGeneratedBarcode = nil
            presentAlert(messageText: "Barcode Generation Failed", informativeText: "The PDF417 generator could not create an image for the provided data.")
        }
    }

    @IBAction func copyBarcodeData(_ sender: Any) {
        guard let barcode = lastGeneratedBarcode else {
            presentAlert(messageText: "No Barcode Data Available", informativeText: "Generate a barcode before copying its data string.")
            return
        }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(barcode.description, forType: .string)
    }

    @IBAction func regenerateDocumentDiscriminator(_ sender: Any) {
        documentDiscriminatorValue = ViewController.makeDocumentDiscriminator()
        updateDocumentDiscriminatorDisplay()
    }

    @IBAction func genderSelectionDidChange(_ sender: NSPopUpButton) {
        persistGenderSelection()
    }

    @IBAction func eyeColorSelectionDidChange(_ sender: NSPopUpButton) {
        persistEyeColorSelection()
    }

    @IBAction func stateSelectionDidChange(_ sender: NSPopUpButton) {
        if let metadata = selectedStateMetadata,
           let index = countryPopupButton.itemArray.firstIndex(where: { ($0.representedObject as? String) == metadata.countryRaw }) {
            countryPopupButton.selectItem(at: index)
            persistCountrySelection()
        }

        persistStateSelection()
    }

    @IBAction func countrySelectionDidChange(_ sender: NSPopUpButton) {
        persistCountrySelection()
    }

    @IBAction func subfileTypeSelectionDidChange(_ sender: NSPopUpButton) {
        persistSubfileTypeSelection()
    }

    @IBAction func barcodeScaleDidChange(_ sender: NSSlider) {
        updateBarcodeScaleLabel()
        persistBarcodeScale()
    }

    @IBAction func saveBarcodeImage(_ sender: Any) {
        guard let rendered = lastRenderedBarcode else {
            presentAlert(messageText: "No Barcode Available", informativeText: "Generate a barcode before exporting an image.")
            return
        }

        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png"]
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = "drivers-license-barcode.png"

        let completion: (NSApplication.ModalResponse) -> Void = { response in
            guard response == .OK, let url = panel.url else { return }

            let bitmap = NSBitmapImageRep(cgImage: rendered.cgImage)
            bitmap.size = rendered.image.size

            guard let data = bitmap.representation(using: .png, properties: [:]) else {
                self.presentAlert(messageText: "Export Failed", informativeText: "The PNG encoder could not create image data.")
                return
            }

            do {
                try data.write(to: url)
            } catch {
                self.presentAlert(messageText: "Export Failed", informativeText: "\(error.localizedDescription)")
            }
        }

        if let window = view.window {
            panel.beginSheetModal(for: window, completionHandler: completion)
        } else {
            completion(panel.runModal())
        }
    }

    @IBAction func jurisdictionFilterChanged(_ sender: NSSearchField) {
        let query = sender.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let previouslySelectedCode = selectedStateMetadata?.code

        if query.isEmpty {
            filteredJurisdictionOptions = ViewController.jurisdictionOptions.sorted { $0.name < $1.name }
        } else {
            filteredJurisdictionOptions = ViewController.jurisdictionOptions.filter { option in
                option.name.lowercased().contains(query) || option.code.lowercased().contains(query)
            }.sorted { $0.name < $1.name }
        }

        reloadStateMenu(selecting: previouslySelectedCode)
    }

    // MARK: - Helpers

    func renderPDF417Barcode(from barcode: Barcode) throws -> RenderedBarcode {
        let data = try barcode.encodedData()

        guard let filter = CIFilter(name: "CIPDF417BarcodeGenerator") else {
            throw BarcodeRenderingError.generatorUnavailable
        }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(NSNumber(value: 4.0), forKey: "inputQuietSpace")
        filter.setValue(NSNumber(value: 4.0), forKey: "inputPreferredAspectRatio")
        filter.setValue(NSNumber(value: 3), forKey: "inputCompactionMode")

        guard let outputImage = filter.outputImage else {
            throw BarcodeRenderingError.outputFailure
        }

        let transform = CGAffineTransform(scaleX: barcodeScale, y: barcodeScale)
        let scaledImage = outputImage.transformed(by: transform)
        guard let cgImage = scaledImage.toCGImage() else {
            throw BarcodeRenderingError.outputFailure
        }

        let size = NSSize(width: scaledImage.extent.width, height: scaledImage.extent.height)
        let image = NSImage(cgImage: cgImage, size: size)
        return RenderedBarcode(image: image, cgImage: cgImage)
    }

    private func validateInputs() -> [ValidationIssue] {
        var issues: [ValidationIssue] = []

        if issuerIdentificationNumber.count != 6 || !issuerIdentificationNumber.allSatisfy({ $0.isNumber }) {
            issues.append(ValidationIssue(message: "Issuer Identification Number must be 6 digits.", control: issuerIdentificationNumberTextField))
        }

        if aamvaVersionNumber.count != 2 || !aamvaVersionNumber.allSatisfy({ $0.isNumber }) {
            issues.append(ValidationIssue(message: "AAMVA version must be a two-digit number.", control: aamvaVersionNumberTextField))
        }

        if jurisdictionVersionNumber.count != 2 || !jurisdictionVersionNumber.allSatisfy({ $0.isNumber }) {
            issues.append(ValidationIssue(message: "Jurisdiction version must be a two-digit number.", control: jurisdictionVersionNumberTextField))
        }

        if customerFamilyName.isEmpty {
            issues.append(ValidationIssue(message: "Last name is required.", control: lastNameTextField))
        }

        if customerFirstName.isEmpty {
            issues.append(ValidationIssue(message: "First name is required.", control: firstNameTextField))
        }

        if addressStreet1.isEmpty {
            issues.append(ValidationIssue(message: "Address line 1 is required.", control: address1TextField))
        }

        if addressCity.isEmpty {
            issues.append(ValidationIssue(message: "City is required.", control: cityTextField))
        }

        if addressJurisdictionCode.isEmpty {
            issues.append(ValidationIssue(message: "Select a jurisdiction.", control: statePopupButton))
        }

        if addressPostalCode.isEmpty {
            issues.append(ValidationIssue(message: "Postal code is required.", control: zipTextField))
        }

        if customerIDNumber.isEmpty {
            issues.append(ValidationIssue(message: "Customer ID is required.", control: customerIDNumberTextField))
        }

        if let parsedHeight = HeightParser.inches(from: physicalDescriptionHeightTextField.stringValue) {
            if parsedHeight < 36 || parsedHeight > 110 {
                issues.append(ValidationIssue(message: "Height must be between 36 and 110 inches.", control: physicalDescriptionHeightTextField))
            }
        } else {
            issues.append(ValidationIssue(message: "Enter height in inches, feet/inches, or centimeters.", control: physicalDescriptionHeightTextField))
        }

        if trimmedValue(from: documentDiscriminatorTextField).isEmpty {
            issues.append(ValidationIssue(message: "Document discriminator is required.", control: documentDiscriminatorTextField))
        }

        if documentExpirationDate < documentIssueDate {
            issues.append(ValidationIssue(message: "Expiration date must be after the issue date.", control: expirationDatePicker))
            issues.append(ValidationIssue(message: "Expiration date must be after the issue date.", control: issueDatePicker))
        }

        if documentIssueDate < dateOfBirth {
            issues.append(ValidationIssue(message: "Issue date cannot precede the date of birth.", control: issueDatePicker))
            issues.append(ValidationIssue(message: "Issue date cannot precede the date of birth.", control: dateOfBirthDatePicker))
        }

        return issues
    }

    private func presentAlert(messageText: String, informativeText: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.runModal()
    }

    private func configureSearchField() {
        stateFilterSearchField.target = self
        stateFilterSearchField.action = #selector(jurisdictionFilterChanged(_:))
        stateFilterSearchField.placeholderString = "Search jurisdictions"
        stateFilterSearchField.sendsSearchStringImmediately = true
        stateFilterSearchField.sendsWholeSearchString = true
    }

    private func configurePopUpMenus() {
        configureGenderMenu()
        configureEyeColorMenu()
        configureCountryMenu()
        configureSubfileTypeMenu()
        reloadStateMenu(selecting: nil)
    }

    private func configureGenderMenu() {
        sexPopupButton.removeAllItems()

        let options = DataElementGender.allCases.sorted { displayTitle(forGender: $0) < displayTitle(forGender: $1) }
        options.forEach { gender in
            let title = displayTitle(forGender: gender)
            sexPopupButton.addItem(withTitle: title)
            sexPopupButton.itemArray.last?.representedObject = NSNumber(value: gender.rawValue)
        }

        sexPopupButton.target = self
        sexPopupButton.action = #selector(genderSelectionDidChange(_:))

        if let defaultIndex = sexPopupButton.itemArray.firstIndex(where: { ($0.representedObject as? NSNumber)?.intValue == DataElementGender.NotSpecified.rawValue }) {
            sexPopupButton.selectItem(at: defaultIndex)
        }
    }

    private func configureEyeColorMenu() {
        eyeColor.removeAllItems()

        DataElementEyeColor.allCases
            .sorted { displayTitle(forEyeColor: $0) < displayTitle(forEyeColor: $1) }
            .forEach { color in
                let title = displayTitle(forEyeColor: color)
                eyeColor.addItem(withTitle: title)
                eyeColor.itemArray.last?.representedObject = color.rawValue
            }

        eyeColor.target = self
        eyeColor.action = #selector(eyeColorSelectionDidChange(_:))

        if let defaultIndex = eyeColor.itemArray.firstIndex(where: { ($0.representedObject as? String) == DataElementEyeColor.Unknown.rawValue }) {
            eyeColor.selectItem(at: defaultIndex)
        }
    }

    private func configureCountryMenu() {
        countryPopupButton.removeAllItems()

        ViewController.countryOptions
            .sorted { $0.title < $1.title }
            .forEach { option in
            countryPopupButton.addItem(withTitle: option.title)
            countryPopupButton.itemArray.last?.representedObject = option.value.rawValue
        }

        countryPopupButton.target = self
        countryPopupButton.action = #selector(countrySelectionDidChange(_:))

        if let defaultIndex = countryPopupButton.itemArray.firstIndex(where: { ($0.representedObject as? String) == DataElementCountryIdentificationCode.US.rawValue }) {
            countryPopupButton.selectItem(at: defaultIndex)
        }
    }

    private func configureSubfileTypeMenu() {
        subfileTypePopUpButton.removeAllItems()

        SubfileType.allCases.forEach { type in
            let title = displayTitle(forSubfileType: type)
            subfileTypePopUpButton.addItem(withTitle: title)
            subfileTypePopUpButton.itemArray.last?.representedObject = type.rawValue
        }

        subfileTypePopUpButton.target = self
        subfileTypePopUpButton.action = #selector(subfileTypeSelectionDidChange(_:))

        if let defaultIndex = subfileTypePopUpButton.itemArray.firstIndex(where: { ($0.representedObject as? String) == SubfileType.DL.rawValue }) {
            subfileTypePopUpButton.selectItem(at: defaultIndex)
        }
    }

    private func reloadStateMenu(selecting code: String?) {
        statePopupButton.removeAllItems()

        guard !filteredJurisdictionOptions.isEmpty else {
            statePopupButton.isEnabled = false
            statePopupButton.addItem(withTitle: "No matches")
            statePopupButton.target = nil
            statePopupButton.action = nil
            return
        }

        filteredJurisdictionOptions.forEach { option in
            let title = "\(option.name) (\(option.code))"
            statePopupButton.addItem(withTitle: title)
            statePopupButton.itemArray.last?.representedObject = ["code": option.code, "country": option.country.rawValue]
        }

        statePopupButton.isEnabled = true
        statePopupButton.target = self
        statePopupButton.action = #selector(stateSelectionDidChange(_:))

        if let code = code,
           let index = statePopupButton.itemArray.firstIndex(where: { ($0.representedObject as? [String: String])?["code"] == code }) {
            statePopupButton.selectItem(at: index)
        } else if let storedCode = defaults.string(forKey: DefaultsKey.selectedStateCode),
                  let storedIndex = statePopupButton.itemArray.firstIndex(where: { ($0.representedObject as? [String: String])?["code"] == storedCode }) {
            statePopupButton.selectItem(at: storedIndex)
        } else {
            statePopupButton.selectItem(at: 0)
        }

        if statePopupButton.selectedItem != nil {
            persistStateSelection()
        }
    }

    private func restorePersistedSelections() {
        restorePersistedTextFields()

        if issuerIdentificationNumberTextField.stringValue.isEmpty {
            issuerIdentificationNumberTextField.stringValue = "636000"
        }

        if aamvaVersionNumberTextField.stringValue.isEmpty {
            aamvaVersionNumberTextField.stringValue = "08"
        }

        if jurisdictionVersionNumberTextField.stringValue.isEmpty {
            jurisdictionVersionNumberTextField.stringValue = "00"
        }

        if let storedGender = defaults.value(forKey: DefaultsKey.selectedGender) as? Int,
           let index = sexPopupButton.itemArray.firstIndex(where: { ($0.representedObject as? NSNumber)?.intValue == storedGender }) {
            sexPopupButton.selectItem(at: index)
        }

        if let storedEyeColor = defaults.string(forKey: DefaultsKey.selectedEyeColor),
           let index = eyeColor.itemArray.firstIndex(where: { ($0.representedObject as? String) == storedEyeColor }) {
            eyeColor.selectItem(at: index)
        }

        if let storedCountry = defaults.string(forKey: DefaultsKey.selectedCountry),
           let index = countryPopupButton.itemArray.firstIndex(where: { ($0.representedObject as? String) == storedCountry }) {
            countryPopupButton.selectItem(at: index)
        }

        if let storedState = defaults.string(forKey: DefaultsKey.selectedStateCode) {
            reloadStateMenu(selecting: storedState)
        }

        if let storedSubfileType = defaults.string(forKey: DefaultsKey.selectedSubfileType),
           let index = subfileTypePopUpButton.itemArray.firstIndex(where: { ($0.representedObject as? String) == storedSubfileType }) {
            subfileTypePopUpButton.selectItem(at: index)
        }

        let storedScale = defaults.object(forKey: DefaultsKey.barcodeScale) as? Double ?? 5.0
        let clampedScale = min(max(storedScale, barcodeScaleSlider.minValue), barcodeScaleSlider.maxValue)
        barcodeScaleSlider.doubleValue = clampedScale
        updateBarcodeScaleLabel()
    }

    private func persistGenderSelection() {
        if let value = sexPopupButton.selectedItem?.representedObject as? NSNumber {
            defaults.set(value.intValue, forKey: DefaultsKey.selectedGender)
        }

        clearValidationHighlight(for: sexPopupButton)
    }

    private func persistEyeColorSelection() {
        if let value = eyeColor.selectedItem?.representedObject as? String {
            defaults.set(value, forKey: DefaultsKey.selectedEyeColor)
        }

        clearValidationHighlight(for: eyeColor)
    }

    private func persistStateSelection() {
        if let value = statePopupButton.selectedItem?.representedObject as? [String: String],
           let code = value["code"] {
            defaults.set(code, forKey: DefaultsKey.selectedStateCode)
        }

        clearValidationHighlight(for: statePopupButton)
    }

    private func persistCountrySelection() {
        if let value = countryPopupButton.selectedItem?.representedObject as? String {
            defaults.set(value, forKey: DefaultsKey.selectedCountry)
        }

        clearValidationHighlight(for: countryPopupButton)
    }

    private func persistSubfileTypeSelection() {
        if let rawValue = subfileTypePopUpButton.selectedItem?.representedObject as? String {
            defaults.set(rawValue, forKey: DefaultsKey.selectedSubfileType)
        }

        clearValidationHighlight(for: subfileTypePopUpButton)
    }

    private func persistBarcodeScale() {
        defaults.set(barcodeScaleSlider.doubleValue, forKey: DefaultsKey.barcodeScale)
    }

    @objc private func textFieldDidChange(_ notification: Notification) {
        guard let textField = notification.object as? NSTextField else { return }

        if let key = textFieldDefaultsMap[textField] {
            defaults.set(textField.stringValue, forKey: key)
        }

        clearValidationHighlight(for: textField)
    }

    @objc private func datePickerDidChange(_ sender: NSDatePicker) {
        clearValidationHighlight(for: sender)
    }

    private func middleNameComponents(from string: String) -> [String] {
        return string
            .split { $0.isWhitespace }
            .map { String($0) }
    }

    private func updateBarcodeScaleLabel() {
        barcodeScaleLabel.stringValue = String(format: "Scale: %.1fx", barcodeScaleSlider.doubleValue)
    }

    private func updateDocumentDiscriminatorDisplay() {
        documentDiscriminatorTextField.stringValue = documentDiscriminatorValue
        documentDiscriminatorTextField.isEditable = true
        documentDiscriminatorTextField.isSelectable = true
    }

    private func trimmedValue(from textField: NSTextField) -> String {
        return textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var middleNameComponents: [String] {
        return middleNameComponents(from: trimmedValue(from: middleNameTextField))
    }

    private var joinedMiddleNames: String {
        return middleNameComponents.joined(separator: " ")
    }

    private var lastNameTruncation: DataElementTruncation {
        return truncationStatus(forSanitizedValue: sanitizedFamilyName, limit: 40)
    }

    private var firstNameTruncation: DataElementTruncation {
        return truncationStatus(forSanitizedValue: sanitizedFirstName, limit: 40)
    }

    private var middleNameTruncation: DataElementTruncation {
        return truncationStatus(forSanitizedValue: sanitizedMiddleNameBlock, limit: 40)
    }

    private func truncationStatus(forSanitizedValue value: String, limit: Int) -> DataElementTruncation {
        return value.count > limit ? .Yes : .No
    }
}

// MARK: - Private helpers

private extension ViewController {
    struct ValidationIssue {
        let message: String
        let control: NSControl
    }

    struct StateMetadata {
        let code: String
        let countryRaw: String
    }

    struct JurisdictionOption {
        let name: String
        let code: String
        let country: DataElementCountryIdentificationCode
    }

    struct CountryOption {
        let title: String
        let value: DataElementCountryIdentificationCode
    }

    struct RenderedBarcode {
        let image: NSImage
        let cgImage: CGImage
    }

    enum DefaultsKey {
        static let selectedGender = "ViewController.selectedGender"
        static let selectedEyeColor = "ViewController.selectedEyeColor"
        static let selectedStateCode = "ViewController.selectedState"
        static let selectedCountry = "ViewController.selectedCountry"
        static let firstName = "ViewController.firstName"
        static let middleName = "ViewController.middleName"
        static let lastName = "ViewController.lastName"
        static let addressLine1 = "ViewController.addressLine1"
        static let addressLine2 = "ViewController.addressLine2"
        static let city = "ViewController.city"
        static let postalCode = "ViewController.postalCode"
        static let vehicleClass = "ViewController.vehicleClass"
        static let endorsementCodes = "ViewController.endorsementCodes"
        static let restrictionCodes = "ViewController.restrictionCodes"
        static let height = "ViewController.height"
        static let customerId = "ViewController.customerId"
        static let issuerIdentificationNumber = "ViewController.issuerIdentificationNumber"
        static let aamvaVersionNumber = "ViewController.aamvaVersionNumber"
        static let jurisdictionVersionNumber = "ViewController.jurisdictionVersionNumber"
        static let documentDiscriminator = "ViewController.documentDiscriminator"
        static let barcodeScale = "ViewController.barcodeScale"
        static let selectedSubfileType = "ViewController.selectedSubfileType"
    }

    var selectedStateMetadata: StateMetadata? {
        guard let metadata = statePopupButton.selectedItem?.representedObject as? [String: String],
              let code = metadata["code"],
              let country = metadata["country"] else {
            return nil
        }

        return StateMetadata(code: code, countryRaw: country)
    }

    static func makeDocumentDiscriminator() -> String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(25).uppercased()
    }

    func configureTextFieldPersistence() {
        textFieldDefaultsMap = [
            firstNameTextField: DefaultsKey.firstName,
            middleNameTextField: DefaultsKey.middleName,
            lastNameTextField: DefaultsKey.lastName,
            address1TextField: DefaultsKey.addressLine1,
            address2TextField: DefaultsKey.addressLine2,
            cityTextField: DefaultsKey.city,
            zipTextField: DefaultsKey.postalCode,
            jurisdictionSpecificVehicleClassTextField: DefaultsKey.vehicleClass,
            jurisdictionSpecificEndorsementCodesTextField: DefaultsKey.endorsementCodes,
            jurisdictionSpecificRestrictionCodesTextField: DefaultsKey.restrictionCodes,
            physicalDescriptionHeightTextField: DefaultsKey.height,
            customerIDNumberTextField: DefaultsKey.customerId,
            issuerIdentificationNumberTextField: DefaultsKey.issuerIdentificationNumber,
            aamvaVersionNumberTextField: DefaultsKey.aamvaVersionNumber,
            jurisdictionVersionNumberTextField: DefaultsKey.jurisdictionVersionNumber,
            documentDiscriminatorTextField: DefaultsKey.documentDiscriminator,
        ]

        textFieldDefaultsMap.keys.forEach { textField in
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: NSControl.textDidChangeNotification, object: textField)
        }

        [expirationDatePicker, issueDatePicker, dateOfBirthDatePicker].forEach { picker in
            picker?.target = self
            picker?.action = #selector(datePickerDidChange(_:))
        }
    }

    func restorePersistedTextFields() {
        textFieldDefaultsMap.forEach { textField, key in
            if let storedValue = defaults.string(forKey: key) {
                textField.stringValue = storedValue
            }
        }
    }

    func clearValidationHighlight(for control: NSControl) {
        control.toolTip = nil
        control.wantsLayer = true
        control.layer?.borderWidth = 0
        control.layer?.borderColor = nil
        control.layer?.cornerRadius = 0
    }

    func clearValidationHighlights() {
        let controls: [NSControl] = [
            firstNameTextField,
            middleNameTextField,
            lastNameTextField,
            address1TextField,
            address2TextField,
            cityTextField,
            zipTextField,
            statePopupButton,
            countryPopupButton,
            physicalDescriptionHeightTextField,
            customerIDNumberTextField,
            issuerIdentificationNumberTextField,
            aamvaVersionNumberTextField,
            jurisdictionVersionNumberTextField,
            jurisdictionSpecificVehicleClassTextField,
            jurisdictionSpecificEndorsementCodesTextField,
            jurisdictionSpecificRestrictionCodesTextField,
            documentDiscriminatorTextField,
            expirationDatePicker,
            issueDatePicker,
            dateOfBirthDatePicker,
        ]

        controls.forEach { control in
            clearValidationHighlight(for: control)
        }
    }

    func applyValidationIssues(_ issues: [ValidationIssue]) {
        var aggregatedIssues: [ObjectIdentifier: (control: NSControl, messages: [String])] = [:]

        issues.forEach { issue in
            let identifier = ObjectIdentifier(issue.control)
            if var entry = aggregatedIssues[identifier] {
                entry.messages.append(issue.message)
                aggregatedIssues[identifier] = entry
            } else {
                aggregatedIssues[identifier] = (issue.control, [issue.message])
            }
        }

        aggregatedIssues.values.forEach { entry in
            let combinedMessage = entry.messages.joined(separator: "\n")
            highlight(control: entry.control, message: combinedMessage)
        }

        if let firstControl = issues.first?.control {
            view.window?.makeFirstResponder(firstControl)
        }
    }

    func highlight(control: NSControl, message: String) {
        control.wantsLayer = true
        control.layer?.borderWidth = 2
        control.layer?.cornerRadius = 4
        control.layer?.borderColor = NSColor.systemRed.cgColor
        control.toolTip = message
    }

    static var jurisdictionOptions: [JurisdictionOption] {
        return [
            JurisdictionOption(name: "Alabama", code: "AL", country: .US),
            JurisdictionOption(name: "Alaska", code: "AK", country: .US),
            JurisdictionOption(name: "Arizona", code: "AZ", country: .US),
            JurisdictionOption(name: "Arkansas", code: "AR", country: .US),
            JurisdictionOption(name: "California", code: "CA", country: .US),
            JurisdictionOption(name: "Colorado", code: "CO", country: .US),
            JurisdictionOption(name: "Connecticut", code: "CT", country: .US),
            JurisdictionOption(name: "Delaware", code: "DE", country: .US),
            JurisdictionOption(name: "District of Columbia", code: "DC", country: .US),
            JurisdictionOption(name: "Florida", code: "FL", country: .US),
            JurisdictionOption(name: "Georgia", code: "GA", country: .US),
            JurisdictionOption(name: "Hawaii", code: "HI", country: .US),
            JurisdictionOption(name: "Idaho", code: "ID", country: .US),
            JurisdictionOption(name: "Illinois", code: "IL", country: .US),
            JurisdictionOption(name: "Indiana", code: "IN", country: .US),
            JurisdictionOption(name: "Iowa", code: "IA", country: .US),
            JurisdictionOption(name: "Kansas", code: "KS", country: .US),
            JurisdictionOption(name: "Kentucky", code: "KY", country: .US),
            JurisdictionOption(name: "Louisiana", code: "LA", country: .US),
            JurisdictionOption(name: "Maine", code: "ME", country: .US),
            JurisdictionOption(name: "Maryland", code: "MD", country: .US),
            JurisdictionOption(name: "Massachusetts", code: "MA", country: .US),
            JurisdictionOption(name: "Michigan", code: "MI", country: .US),
            JurisdictionOption(name: "Minnesota", code: "MN", country: .US),
            JurisdictionOption(name: "Mississippi", code: "MS", country: .US),
            JurisdictionOption(name: "Missouri", code: "MO", country: .US),
            JurisdictionOption(name: "Montana", code: "MT", country: .US),
            JurisdictionOption(name: "Nebraska", code: "NE", country: .US),
            JurisdictionOption(name: "Nevada", code: "NV", country: .US),
            JurisdictionOption(name: "New Hampshire", code: "NH", country: .US),
            JurisdictionOption(name: "New Jersey", code: "NJ", country: .US),
            JurisdictionOption(name: "New Mexico", code: "NM", country: .US),
            JurisdictionOption(name: "New York", code: "NY", country: .US),
            JurisdictionOption(name: "North Carolina", code: "NC", country: .US),
            JurisdictionOption(name: "North Dakota", code: "ND", country: .US),
            JurisdictionOption(name: "Ohio", code: "OH", country: .US),
            JurisdictionOption(name: "Oklahoma", code: "OK", country: .US),
            JurisdictionOption(name: "Oregon", code: "OR", country: .US),
            JurisdictionOption(name: "Pennsylvania", code: "PA", country: .US),
            JurisdictionOption(name: "Rhode Island", code: "RI", country: .US),
            JurisdictionOption(name: "South Carolina", code: "SC", country: .US),
            JurisdictionOption(name: "South Dakota", code: "SD", country: .US),
            JurisdictionOption(name: "Tennessee", code: "TN", country: .US),
            JurisdictionOption(name: "Texas", code: "TX", country: .US),
            JurisdictionOption(name: "Utah", code: "UT", country: .US),
            JurisdictionOption(name: "Vermont", code: "VT", country: .US),
            JurisdictionOption(name: "Virginia", code: "VA", country: .US),
            JurisdictionOption(name: "Washington", code: "WA", country: .US),
            JurisdictionOption(name: "West Virginia", code: "WV", country: .US),
            JurisdictionOption(name: "Wisconsin", code: "WI", country: .US),
            JurisdictionOption(name: "Wyoming", code: "WY", country: .US),
            JurisdictionOption(name: "Alberta", code: "AB", country: .CA),
            JurisdictionOption(name: "British Columbia", code: "BC", country: .CA),
            JurisdictionOption(name: "Manitoba", code: "MB", country: .CA),
            JurisdictionOption(name: "New Brunswick", code: "NB", country: .CA),
            JurisdictionOption(name: "Newfoundland and Labrador", code: "NL", country: .CA),
            JurisdictionOption(name: "Nova Scotia", code: "NS", country: .CA),
            JurisdictionOption(name: "Ontario", code: "ON", country: .CA),
            JurisdictionOption(name: "Prince Edward Island", code: "PE", country: .CA),
            JurisdictionOption(name: "Quebec", code: "QC", country: .CA),
            JurisdictionOption(name: "Saskatchewan", code: "SK", country: .CA),
            JurisdictionOption(name: "Northwest Territories", code: "NT", country: .CA),
            JurisdictionOption(name: "Nunavut", code: "NU", country: .CA),
            JurisdictionOption(name: "Yukon", code: "YT", country: .CA)
        ]
    }

    static var countryOptions: [CountryOption] {
        return [
            CountryOption(title: "United States", value: .US),
            CountryOption(title: "Canada", value: .CA),
            CountryOption(title: "Mexico", value: .MX),
            CountryOption(title: "Australia", value: .AU),
            CountryOption(title: "United Kingdom", value: .GB),
            CountryOption(title: "Germany", value: .DE),
            CountryOption(title: "France", value: .FR),
            CountryOption(title: "Japan", value: .JP),
            CountryOption(title: "Austria", value: .AT),
            CountryOption(title: "Belgium", value: .BE),
            CountryOption(title: "Brazil", value: .BR),
            CountryOption(title: "China", value: .CN),
            CountryOption(title: "Denmark", value: .DK),
            CountryOption(title: "Spain", value: .ES),
            CountryOption(title: "Finland", value: .FI),
            CountryOption(title: "Ireland", value: .IE),
            CountryOption(title: "Israel", value: .IL),
            CountryOption(title: "India", value: .IN),
            CountryOption(title: "Italy", value: .IT),
            CountryOption(title: "South Korea", value: .KR),
            CountryOption(title: "Netherlands", value: .NL),
            CountryOption(title: "New Zealand", value: .NZ),
            CountryOption(title: "Philippines", value: .PH),
            CountryOption(title: "Sweden", value: .SE),
            CountryOption(title: "Singapore", value: .SG),
            CountryOption(title: "South Africa", value: .ZA)
        ]
    }

    func displayTitle(forGender gender: DataElementGender) -> String {
        switch gender {
        case .Male:
            return "Male"
        case .Female:
            return "Female"
        case .NotSpecified:
            return "Not Specified"
        case .NonBinary:
            return "Non-Binary"
        }
    }

    func displayTitle(forEyeColor color: DataElementEyeColor) -> String {
        switch color {
        case .Black:
            return "Black"
        case .Blue:
            return "Blue"
        case .Brown:
            return "Brown"
        case .Amber:
            return "Amber"
        case .Dichromaic:
            return "Dichromatic"
        case .Gray:
            return "Gray"
        case .Green:
            return "Green"
        case .Hazel:
            return "Hazel"
        case .Maroon:
            return "Maroon"
        case .Pink:
            return "Pink"
        case .Unknown:
            return "Unknown"
        }
    }

    func displayTitle(forSubfileType type: SubfileType) -> String {
        switch type {
        case .DL:
            return "Driver License (DL)"
        case .ID:
            return "Identification Card (ID)"
        }
    }
}
