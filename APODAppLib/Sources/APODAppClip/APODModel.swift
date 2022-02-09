import Foundation
import Combine
import APODKit
import CoreImage
import LoggingKit

public class APODModel: ObservableObject {

    public typealias Dependencies = HasFileManagerType & HasCacheType & HasNetworkClientType

    private let store: APODStore

    @Published var date = Date()
    @Published var apodItem: APODViewItem?

    var cancellables = Set<AnyCancellable>()

    public init(dependencies: Dependencies) {

        store = APODStore(dependencies: dependencies)

        $date.sink { date in
            self.fetch(date: date)
        }
        .store(in: &cancellables)
    }

    func fetch(date: Date) {
        Task {
            do {
                let item = try await store.apod(for: date)
                DispatchQueue.main.async {
                    self.apodItem = item.mapToViewItem()
                }
            } catch {
                Log.error(error)
            }
        }
    }
}

extension APODItem.APODAsset {
    func mapToViewAsset() -> APODAssetViewItem {
        switch self {
        case let .video(url):
            return .video(url)
        case let .image(url):
            do {
                let data = try Data(contentsOfFile: url.lastPathComponent)
                let provider = try data.toCGDataProvider()
                let cgImage = try provider.toCGImage()
                return .image(cgImage)
            } catch {
                return .placeholder
            }
        }
    }
}

extension APODItem {
    func mapToViewItem() -> APODViewItem {
        APODViewItem(title: self.title,
                     asset: asset.mapToViewAsset(),
                     explanation: self.explanation)
    }
}
