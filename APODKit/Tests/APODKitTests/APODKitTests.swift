import Quick
import Nimble
import Foundation
@testable import APODKit


final class APODKitTests: QuickSpec {
    override func spec() {
        var subject: APODStore!
        var mockDependencies = MockDependencies()

        beforeEach {
            mockDependencies = MockDependencies()
            subject = APODStore(dependencies: mockDependencies)
        }

        describe("fetching apod") {

            var apod: APODItem? = nil

            context("when there is an apod in the cache") {

                beforeEach { _ in
                    mockDependencies.mockCache.itemToLoad = APODItem.mockApod
                }

                asyncIt("should return the cached apod") {
                    apod = try! await subject.apod(for: nil)

                    expect(apod).to(equal(APODItem.mockApod))
                }
            }

            context("when there is not an apod in the cache") {

                beforeEach { _ in
                    mockDependencies.mockCache.itemToLoad = nil
                    mockDependencies.mockCache.resultOfSave = APODItem.mockApod
                }

                context("when the network responds") {
                    beforeEach { _ in
                        mockDependencies.mockNetworkClient.responseToReturn = APODResponse.imageResponse

                    }

                    asyncIt("should return the cached apod") {
                        apod = try! await subject.apod(for: nil)

                        expect(apod).to(equal(APODItem.mockApod))
                    }
                }

                context("when the network does not respond") {
                    beforeEach { _ in
                        mockDependencies.mockNetworkClient.responseToReturn = nil
                    }

                    asyncIt("should throw an error") {
                        do {
                            apod = try await subject.apod(for: nil)
                        } catch {
                            guard case let MockError.networkError(errorString) = error else {
                                fail(); return
                            }
                            expect(errorString).to(equal("No Response To Return"))
                        }
                    }
                }

            }
        }
    }
}
