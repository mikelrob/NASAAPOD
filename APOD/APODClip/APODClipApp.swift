import SwiftUI
import APODAppClip
import LoggingKit

@main
struct APODClipApp: App {

    let appController = AppClipController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appController.model)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    Log.debug("\(activity)")
                    guard let url = activity.webpageURL else {
                        Log.debug("Unable to contine \(activity)")
                        return
                    }
                    appController.openURL(url)
                }
                .onOpenURL { url in
                    appController.openURL(url)
                }
        }
    }
}

//file:///Users/mikelrob/Library/Developer/CoreSimulator/Devices/49549726-A669-45CE-8A3B-09D276C3AE7E/data/Containers/Data/Application/7175C69E-8F69-42ED-8135-D835096A0564/Library/Application%20Support/APOD/assets/
//file:///Users/mikelrob/Library/Developer/CoreSimulator/Devices/49549726-A669-45CE-8A3B-09D276C3AE7E/data/Containers/Data/Application/38C725CF-4A32-4E81-BAE3-BD803C6EA72D/Library/Application%20Support/APOD/assets/

