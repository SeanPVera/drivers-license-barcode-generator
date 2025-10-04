import Cocoa
import CoreImage

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        sexPopupButton.removeAllItems()
        sexPopupButton.addItems(withTitles: ["Male", "Female", "Not Specified"])
        sexPopupButton.selectItem(at: 0)

        eyeColor.removeAllItems()
        eyeColor.addItems(withTitles: DataElementEyeColor.allCases.map { $0.rawValue })
        eyeColor.selectItem(at: 0)

        statePopupButton.removeAllItems()
        statePopupButton.addItems(withTitles: ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"])
        statePopupButton.selectItem(at: 0)

        expirationDatePicker.dateValue = Date()
        issueDatePicker.dateValue = Date()
        dateOfBirthDatePicker.dateValue = Date()

        documentDiscriminatorTextField.stringValue = (0..<25).map{ _ in String(Int.random(in: 0...9)) }.joined()

        countryPopupButton.removeAllItems()
        countryPopupButton.addItems(withTitles: DataElementCountryIdentificationCode.allCases.map { $0.rawValue })
        countryPopupButton.selectItem(at: 0)
    }

    @IBOutlet var imageView: NSImageView!
    
    @IBOutlet var firstNameTextField: NSTextField!
    @IBOutlet var middleNameTextField: NSTextField!
    @IBOutlet var lastNameTextField: NSTextField!
    
    @IBOutlet var address1TextField: NSTextField!
    @IBOutlet var cityTextField: NSTextField!
    @IBOutlet var zipTextField: NSTextField!
    @IBOutlet var statePopupButton: NSPopUpButton!
    
    @IBOutlet var expirationDatePicker: NSDatePicker!
    @IBOutlet var issueDatePicker: NSDatePicker!
    @IBOutlet var dateOfBirthDatePicker: NSDatePicker!
    @IBOutlet var sexPopupButton: NSPopUpButton!
    @IBOutlet var eyeColor: NSPopUpButton!
    @IBOutlet var customerIDNumberTextField: NSTextField!
    @IBOutlet var documentDiscriminatorTextField: NSTextField!
    @IBOutlet var countryPopupButton: NSPopUpButton!
    
    @IBOutlet var jurisdictionSpecificVehicleClassTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificEndorsementCodesTextField: NSTextField!
    @IBOutlet var jurisdictionSpecificRestrictionCodesTextField: NSTextField!
    @IBOutlet var physicalDescriptionHeightTextField: NSTextField!

    private var jurisdictionSpecificEndorsementCodes: String {
        return jurisdictionSpecificEndorsementCodesTextField.stringValue
    }
    
    private var jurisdictionSpecificRestrictionCodes: String {
        return jurisdictionSpecificRestrictionCodesTextField.stringValue
    }
    
    private var jurisdictionSpecificVehicleClass: String {
        return jurisdictionSpecificVehicleClassTextField.stringValue
    }
    
    private var documentExpirationDate: Date {
        return expirationDatePicker.dateValue
    }

    private var customerFamilyName: String {
        return lastNameTextField.stringValue;
    }
    
    private var customerFirstName: String {
        return firstNameTextField.stringValue
    }
    
    private var customerMiddleNames: [String] {
        return [middleNameTextField.stringValue]
    }
    
    private var documentIssueDate: Date {
        return issueDatePicker.dateValue;
    }

    private var dateOfBirth: Date {
        return dateOfBirthDatePicker.dateValue
    }

    private var physicalDescriptionSex: DataElementGender {
        switch sexPopupButton.selectedItem?.title {
        case "Male":
            return .Male
        case "Female":
            return .Female
        default:
            return .NotSpecified
        }
    }
    
    private var physicalDescriptionEyeColor: DataElementEyeColor {
        if let selectedTitle = eyeColor.selectedItem?.title {
            return DataElementEyeColor(rawValue: selectedTitle) ?? .Unknown
        }
        return .Unknown
    }
    
    private var physicalDescriptionHeight: Int {
        return physicalDescriptionHeightTextField.integerValue
    }

    private var addressStreet1: String {
        return address1TextField.stringValue;
    }
    
    private var addressCity: String {
        return cityTextField.stringValue
    }

    private var addressJurisdictionCode: String {
        return statePopupButton.selectedItem?.title ?? ""
    }

    private var addressPostalCode: String {
        return zipTextField.stringValue
    }
    
    private var customerIDNumber: String {
        return customerIDNumberTextField.stringValue
    }
    
    private var documentDiscriminator: String {
        return documentDiscriminatorTextField.stringValue
    }

    private var countryIdentification: DataElementCountryIdentificationCode {
        if let selectedTitle = countryPopupButton.selectedItem?.title {
            return DataElementCountryIdentificationCode(rawValue: selectedTitle) ?? .US
        }
        return .US
    }
    
    var dataElements:[Any] {
        return [
            DCA(jurisdictionSpecificVehicleClass),
            DCB(jurisdictionSpecificRestrictionCodes),
            DCD(jurisdictionSpecificEndorsementCodes),
            DBA(documentExpirationDate),
            DCS(customerFamilyName),
            DAC(customerFirstName),
            DAD(customerMiddleNames),
            DBD(documentIssueDate),
            DBB(dateOfBirth),
            DBC(physicalDescriptionSex),
            DAY(physicalDescriptionEyeColor),
            DAU(physicalDescriptionHeight),
            DAG(addressStreet1),
            DAI(addressCity),
            DAJ(addressJurisdictionCode),
            DAK(addressPostalCode),
            DAQ(customerIDNumber),
            DCF(documentDiscriminator),
            DCG(countryIdentification)
        ]
    }

    // MARK: - Actions
    
    @IBAction func generate(sender: Any) {
        let barcode = Barcode(dataElements: dataElements, issuerIdentificationNumber: "636000", AAMVAVersionNumber: "00", jurisdictionVersionNumber: "00")

        if let image = generatePDF417Barcode(from: barcode) {
            imageView.image = image

        }
    }

    // MARK: - Helpers
    
    func generatePDF417Barcode(from barcode: Barcode) -> NSImage? {
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
            filter.setValue(barcode.data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let cgImage = output.toCGImage()
                
                return NSImage(cgImage: cgImage!, size: NSSize(width: 500, height: 100))
            }
        }
        
        return nil
    }
 }

