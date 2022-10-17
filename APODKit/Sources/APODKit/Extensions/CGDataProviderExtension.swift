import Foundation
import CoreGraphics

public extension CGDataProvider {
    func toCGImage() throws -> CGImage {
        if let jpegImage = CGImage(jpegDataProviderSource: self,
                                   decode: nil,
                                   shouldInterpolate: false,
                                   intent: .defaultIntent) {
            return jpegImage
        } else if let pngImage = CGImage(pngDataProviderSource: self,
                                         decode: nil,
                                         shouldInterpolate: false,
                                         intent: .defaultIntent) {
            return pngImage
        } else {
            throw APODKitError.cannotCreateCGImage(self)
        }
    }
}
