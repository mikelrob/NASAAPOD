import WidgetKit
import SwiftUI
import APODKit
import Intents

struct APODWidgetViewItem {
    let title: String
    let image: CGImage?

    static let widgetPlaceHolder = APODWidgetViewItem(title: "Placeholder",
                                                      image: nil)
}


struct APODEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let apod: APODWidgetViewItem
}

struct APODImageView: View {
    let apod: APODWidgetViewItem

    var body: some View {
        if let image = apod.image {
            Image(decorative: image, scale: UIScreen.main.scale)
        } else {
            Image("NASALogo")
        }
    }
}

@main
struct APODWidget: Widget {
    let kind: String = "APODWidget"

    let apodStore = APODStore(dependencies: DependencyInjectionContainer())

    @State var apod: APODWidgetViewItem?

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            APODWidgetEntryView(entry: entry)
                .onAppear {
                print(entry)
            }
        }
        .configurationDisplayName("Astro Pic Of the Day")
        .description("Shows daily pictures of the NASA archives.")
    }
}

struct APODWidget_Previews: PreviewProvider {
    static var previews: some View {
        APODWidgetEntryView(entry: APODEntry(date: Date(),
                                               configuration: ConfigurationIntent(),
                                               apod: .widgetPlaceHolder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
