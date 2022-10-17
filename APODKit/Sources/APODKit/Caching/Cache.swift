import Foundation

public protocol CacheType {
    func load(date: Date) async throws -> APODItem?
    func save(apodStorageItem: APODStorageItem) async throws -> APODItem
}

public protocol HasCacheType {
    var localCache: CacheType { get }
}

public class Cache: CacheType {

    typealias Dependencies = HasFileManagerType

    private typealias Storage = [String: APODStorageItem]
    private let assetsDirectoryURL: URL
    private let assetsItineraryFilePathURL: URL
    private lazy var storage: Storage = loadStorage()

    private let fileManager: FileManagerType
    private let urlSession: URLSessionType

    public init(fileManager: FileManagerType = FileManager(), urlSession: URLSessionType = URLSession.shared) {
        self.fileManager = fileManager
        self.urlSession = urlSession
        assetsDirectoryURL = fileManager.applicationSupportDirectoryURL
            .appendingPathComponent("APOD")
            .appendingPathComponent("assets")

        try? fileManager.createDirectory(at: assetsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        _ = fileManager.changeCurrentDirectoryPath(assetsDirectoryURL.path)
        assetsItineraryFilePathURL = assetsDirectoryURL.appendingPathComponent("assets.plist")
    }

    public func load(date: Date) async throws -> APODItem? {
        let dateString = ISO8601DateFormatter.fullYearWithDashFormatter.string(from: date)
        guard let storedApodItem = self.storage[dateString] else { return nil }
        let apodItem = try await mapToItem(storedApodItem)
        return apodItem
    }

    public func save(apodStorageItem: APODStorageItem) async throws -> APODItem {
        storage[apodStorageItem.date] = apodStorageItem
        persistStorage()
        let apodItem = try await mapToItem(apodStorageItem)
        return apodItem
    }

    fileprivate func mapToItem(_ apodItem: APODStorageItem) async throws -> APODItem {

        switch apodItem.asset {

        case let .video(url):
            return APODItem(title: apodItem.title,
                            asset: APODItem.APODAsset.video(url),
                            explanation: apodItem.explanation)

        case let .image(remoteURL, localURL):

            if let localURL = localURL,
               fileManager.fileExists(atPath: localURL.lastPathComponent),
               fileManager.isReadableFile(atPath: localURL.lastPathComponent) {
                // item is up to date and available
                return APODItem(title: apodItem.title,
                                asset: APODItem.APODAsset.image(localURL),
                                explanation: apodItem.explanation)
            } else {
                // get image and update storage
                let localURL: URL = try await withCheckedThrowingContinuation { continuation in
                    urlSession.downloadTask(with: remoteURL) { tempFileURL, response, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            guard let tempFileURL = tempFileURL, let response = response else {
                                return continuation.resume(throwing: URLError(.badServerResponse))
                            }
                            let filename = [apodItem.date, response.suggestedFilename].compactMap { $0 }.joined(separator: "-")
                            let destinationURL = self.assetsDirectoryURL.appendingPathComponent(filename)
                            do {
                                try self.fileManager.moveItem(at: tempFileURL, to: destinationURL)
                                continuation.resume(returning: (destinationURL))
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    }.resume()
                }

                let newItem = APODStorageItem(date: apodItem.date,
                                              title: apodItem.title,
                                              explanation: apodItem.explanation,
                                              asset: .image(remote: remoteURL, local: localURL))
                self.storage[newItem.date] = newItem
                self.persistStorage()

                return APODItem(title: newItem.title,
                                asset: APODItem.APODAsset.image(localURL),
                                explanation: newItem.explanation)
            }
        }
    }

    private func resetAssetsDirectoryContents() {
        do {
            try fileManager.removeItem(at: assetsDirectoryURL)
            try fileManager.createDirectory(at: assetsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            _ = fileManager.changeCurrentDirectoryPath(assetsDirectoryURL.path)
        } catch {
            print(error)
        }
    }

    private func loadStorage() -> Storage {
        let decoder = PropertyListDecoder()
        guard let data = try? Data(contentsOf: assetsItineraryFilePathURL) else {
            resetAssetsDirectoryContents()
            return [:]
        }

        do {
            storage = try decoder.decode(Storage.self, from: data)
            return storage
        } catch {
            let message = "Exception thrown while decoding APODItem from plist file \(assetsItineraryFilePathURL) - \(error)"
            print(message)
            resetAssetsDirectoryContents()
            return [:]
        }

    }

    private func persistStorage() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(storage)
            try data.write(to: assetsItineraryFilePathURL)
        } catch {
            let message = "Exception thrown while encoding APODItem to plist file \(assetsItineraryFilePathURL) - \(error)"
            print(message)
        }
    }
}
