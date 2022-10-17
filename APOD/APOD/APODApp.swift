import SwiftUI

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

