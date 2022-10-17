import Foundation
import Network
import CoreGraphics

public enum APODKitError: Error {
    case noAPODAvailable
    case cannotReadFromDiskAtPath(String)
    case cannotCreateCGDataProvider(Data)
    case cannotCreateCGImage(CGDataProvider)
}

public struct APODItem {
    public enum APODAsset {
        case video(URL)
        case image(URL)

        var url: URL {
            switch self {
            case let .video(url):
                return url
            case let .image(url):
                return url
            }
        }
    }

    public let title: String
    public let asset: APODAsset
    public let explanation: String
}
extension APODItem.APODAsset: Equatable { }
extension APODItem: Equatable { }

public class APODStore {

    public typealias Dependencies = HasCacheType & HasNetworkClientType

    private let localCache: CacheType
    private let network: NASANetworkClientType

    public init(dependencies: Dependencies) {
        localCache = dependencies.localCache
        network = dependencies.networkClient
    }

    public func apod(for date: Date?) async throws -> APODItem {
        let dateToFetch = date ?? Date()

        // retrieve from cache
        if let apodInfo = try await localCache.load(date: dateToFetch) {
            return apodInfo

        } else { // retrieve from api and store in cache
            let apodResponse = try await network.apod(for: dateToFetch)
            let mappedApodItem = apodResponse.mapToAPODStorageItem(fetchedDate: dateToFetch)
            let apodItem = try await localCache.save(apodStorageItem: mappedApodItem)
            return apodItem
        }
    }
}

private extension APODResponse {
    func mapToAPODStorageItem(fetchedDate: Date) -> APODStorageItem {
        let dateString = ISO8601DateFormatter.fullYearWithDashFormatter.string(from: fetchedDate)

        let asset: APODStorageItem.Asset
        switch self.mediaType {
        case .image:
            asset = .image(remote: url, local: nil)
        case.video:
            asset = .video(url)
        }
        return APODStorageItem(date: self.date ?? dateString,
                               title: self.title,
                               explanation: self.explanation,
                               asset: asset)
    }
}
