import Foundation
@testable import APODKit

class MockNetworkClient: NASANetworkClientType {

    var responseToReturn: APODResponse?

    func apod(for date: Date) async throws -> APODResponse {
        guard let responseToReturn = responseToReturn else {
            throw MockError.networkError("No Response To Return")
        }
        return responseToReturn
    }
}
