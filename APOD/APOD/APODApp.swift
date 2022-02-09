import SwiftUI
import APODApp

@main
struct APODApp: App {

    private let appController = AppController()

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
