import SwiftUI
import APODKit

@main
struct APODApp: App {

    let dependencies = DependencyInjectionContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(APODModel(dependencies: dependencies))
        }
    }
}
