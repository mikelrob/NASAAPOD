import Foundation
@testable import APODKit

class MockDependencies {
    let mockFileManager = MockFileManager()
    let mockCache = MockCache()
    let mockNetworkClient = MockNetworkClient()
}

extension MockDependencies: HasFileManagerType {
    var fileManager: FileManagerType { mockFileManager }
}
extension MockDependencies: HasCacheType {
    var localCache: CacheType { mockCache }
}
extension MockDependencies: HasNetworkClientType {
    var networkClient: NASANetworkClientType { mockNetworkClient }
}
