import Foundation 

@testable import APODKit

class MockCache: CacheType {

    var itemToLoad: APODItem?
    var resultOfSave: APODItem?

    func load(date: Date) async throws -> APODItem? {
        return itemToLoad
    }

    func save(apodStorageItem: APODStorageItem) async throws -> APODItem {
        guard let resultOfSave = resultOfSave else {
            throw MockError.cacheSaveError("Can not save item to cache")
        }
        return resultOfSave
    }
}
