import Quick
import Nimble
import Foundation
@testable import APODKit

class NASAApiTests: QuickSpec {

    override func spec() {
        describe("baseURL") {
            it("should always have a value") {
                expect(NASAApi.apod(date: Date()).baseURL).toNot(beNil())
            }
        }
    }
}
