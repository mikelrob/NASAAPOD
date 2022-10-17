import Foundation
import Moya

public class DependencyInjectionContainer {
    public let networkClient: NASANetworkClientType
    public let fileManager: FileManagerType
    public let localCache: CacheType

    public init() {

        networkClient = NASANetworkClient()
        fileManager = FileManager.default
        localCache = Cache(fileManager: fileManager, urlSession: URLSession.shared)
    }
}

extension DependencyInjectionContainer: HasFileManagerType {}
extension DependencyInjectionContainer: HasCacheType {}
extension DependencyInjectionContainer: HasNetworkClientType {}
