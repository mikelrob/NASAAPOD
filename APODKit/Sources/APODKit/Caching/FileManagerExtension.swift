import Foundation

public protocol FileManagerType {
    var applicationSupportDirectoryURL: URL { get }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws
    func changeCurrentDirectoryPath(_ path: String) -> Bool
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func removeItem(at URL: URL) throws
    func fileExists(atPath path: String) -> Bool
    func isReadableFile(atPath path: String) -> Bool
}

public protocol HasFileManagerType {
    var fileManager: FileManagerType { get }
}

extension FileManager: FileManagerType {
    // swiftlint:disable force_unwrapping
    public var documentsDirectoryURL: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    public var applicationSupportDirectoryURL: URL {
        return urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    // swiftlint:enable force_unwrapping
}
