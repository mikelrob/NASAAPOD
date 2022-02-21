import SwiftUI
import APODKit

@main
struct APODApp: App {

    let appController = AppController()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Text("APOD")
                    }
                RandomApodsView()
                    .tabItem {
                        Text("Random")
                    }
            }
            .environmentObject(appController.model)
            .environmentObject(appController.randomApodsModel)
            .onOpenURL { url in
                appController.openURL(url)
            }
        }
    }
}

struct RandomApodsView: View {

    @EnvironmentObject var model: RandomAPODSModel

    var body: some View {
        NavigationView {
            List(model.items) { item in
                NavigationLink<APODListCell, APODInfoView>(destination: APODInfoView(apodInfo: item)) { APODListCell(apodItem: item) }
            }
        }
        .onAppear {
            model.fetch()
        }
    }
}

class RandomAPODSModel: ObservableObject {
    typealias Dependencies = HasFileManagerType & HasCacheType & HasNetworkClientType

    private let store: APODStore

    @Published var items: [APODViewItem] = []

    init(dependencies: Dependencies) {
        store = APODStore(dependencies: dependencies)
    }

    func fetch(count: Int = 5) {
        Task {
            let randomApods = try await store.randomApods(count: count)
            DispatchQueue.main.async {
                self.items = randomApods.map { $0.mapToViewItem() }
            }
        }
    }
}

class AppController {

    let dependencies = DependencyInjectionContainer()

    let model: APODModel
    let randomApodsModel: RandomAPODSModel

    init() {
        model = APODModel(dependencies: dependencies)
        randomApodsModel = RandomAPODSModel(dependencies: dependencies)
    }

    func openURL(_ url: URL) {
        // parse url
        guard let dateString = url.host,
                let dateFromUrl = ISO8601DateFormatter.fullYearWithDashFormatter.date(from: dateString) else {
            print("Error parsing date from url - \(url)")
            return
        }

        model.date = dateFromUrl
    }
}

struct APODListCell: View {

    let apodItem: APODViewItem

    var body: some View {
        HStack {
            APODAssetView(asset: apodItem.asset)
            VStack {
                Text(apodItem.title)
                Text(apodItem.date)
            }
        }
    }
}
