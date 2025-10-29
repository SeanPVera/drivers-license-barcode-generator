import CoreImage

extension CIImage {
    private static let sharedContext = CIContext(options: nil)

    func toCGImage() -> CGImage? {
        return CIImage.sharedContext.createCGImage(self, from: extent)
    }
}
