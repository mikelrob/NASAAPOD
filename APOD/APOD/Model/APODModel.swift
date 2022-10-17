import Foundation
import Combine
import APODKit
import CoreImage

class APODModel: ObservableObject {

    typealias Dependencies = HasFileManagerType & HasCacheType & HasNetworkClientType

    private let store: APODStore

    @Published var date = Date()
    @Published var apodItem: APODViewItem = .placeholder

    var cancellables = Set<AnyCancellable>()

    init(dependencies: Dependencies) {

        store = APODStore(dependencies: dependencies)

        $date.sink { date in
            self.fetch(date: date)
        }
        .store(in: &cancellables)
    }

    func fetch(date: Date) {
        apodItem = .loading
        Task {
            do {
                let item = try await store.apod(for: date)
                DispatchQueue.main.async {
                    self.apodItem = item.mapToViewItem()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func selectPreviousDay() {
        guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: date) else { return }
        date = previousDay
    }
    
    func selectNextDay() {
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date),
              nextDay <= Date() else { return }
        date = nextDay
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
