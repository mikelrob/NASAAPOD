import Foundation
@testable import APODKit

class MockFileManager: FileManagerType {

    var createDirectoryError: MockError?
    var moveItemError: MockError?
    var removeItemError: MockError?

    var doesFileExit = false
    var isFileReadable = false

    var applicationSupportDirectoryURL: URL { FileManager.default.applicationSupportDirectoryURL }

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        guard let createDirectoryError = createDirectoryError else {
            return
        }
        throw createDirectoryError
    }

    func changeCurrentDirectoryPath(_ path: String) -> Bool {
        return true
    }

    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        guard let moveItemError = moveItemError else {
            return
        }
        throw moveItemError
    }

    func removeItem(at URL: URL) throws {
        guard let removeItemError = removeItemError else {
            return
        }
        throw removeItemError
    }

    func fileExists(atPath path: String) -> Bool {
        return doesFileExit
    }

    func isReadableFile(atPath path: String) -> Bool {
        return isFileReadable
    }
}

