import Foundation
import CoreGraphics

public extension Data {

    init(contentsOfFile path: String) throws {
        guard let nsData = NSData(contentsOfFile: path) else { throw APODKitError.cannotReadFromDiskAtPath(path) }
        self = nsData as Data
    }

    func toCGDataProvider() throws -> CGDataProvider {
        guard let provider = CGDataProvider(data: self as CFData)
        else { throw APODKitError.cannotCreateCGDataProvider(self) }
        return provider
    }
}
