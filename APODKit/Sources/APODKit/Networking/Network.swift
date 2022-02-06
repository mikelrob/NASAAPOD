import Foundation
import Moya

public protocol NASANetworkClientType {
    func apod(for date: Date) async throws -> APODResponse
}

public protocol HasNetworkClientType {
    var networkClient: NASANetworkClientType { get }
}

class NASANetworkClient: NASANetworkClientType {

    private let moyaProvider = MoyaProvider<NASAApi>()

    func apod(for date: Date = Date()) async throws -> APODResponse {
        return try await moyaProvider.request(.apod(date: date))
            .filterSuccessfulStatusCodes()
            .map(APODResponse.self, using: JSONDecoder.apodDecoder)
    }
}

enum MediaType: String, Codable {
    case video
    case image
}

public struct APODResponse: Codable {
    let copyright: String?
    let date: String?
    let explanation: String
    let hdurl: URL?
    let mediaType: MediaType
    let serviceVersion: String?
    let title: String
    let url: URL
}
