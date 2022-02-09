import SwiftUI
import APODKit

@main
struct APODApp: App {

    let appController = AppController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appController.model)
                .onOpenURL { url in
                    appController.openURL(url)
                }
        }
    }
}

class AppController {

    let dependencies = DependencyInjectionContainer()

    let model: APODModel

    init() {
        model = APODModel(dependencies: dependencies)
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
