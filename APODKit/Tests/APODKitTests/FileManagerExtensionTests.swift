import Quick
import Nimble
import Foundation
@testable import APODKit

class FileManagerExtensionTests: QuickSpec {

    override func spec() {
        describe("documentsDirectoryURL") {
            it("should always have a first value") {
                expect(FileManager().documentsDirectoryURL).toNot(beNil())
            }
        }

        describe("applicationSupportDirectoryURL") {
            it("should always have a first value") {
                expect(FileManager().applicationSupportDirectoryURL).toNot(beNil())
            }
        }
    }
}
