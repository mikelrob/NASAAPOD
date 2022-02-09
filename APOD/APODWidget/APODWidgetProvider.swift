import WidgetKit
import Intents
import APODKit
import SwiftUI

struct Provider: IntentTimelineProvider {

//    private let apodStore: APODStore
//
//    init(apodStore: APODStore) {
//        self.apodStore = apodStore
//    }

    func placeholder(in context: Context) -> APODEntry {
        print("\(#function)")
        return APODEntry(date: Date(),
                         configuration: ConfigurationIntent(),
                         apod: APODWidgetViewItem.widgetPlaceHolder)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (APODEntry) -> ()) {
        print("\(#function)")
        let entry = APODEntry(date: Date(),
                              configuration: configuration,
                              apod: APODWidgetViewItem.widgetPlaceHolder)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<APODEntry>) -> ()) {
        print("\(#function)")
        var entries: [APODEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = APODEntry(date: entryDate,
                                  configuration: configuration,
                                  apod: APODWidgetViewItem.widgetPlaceHolder)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct APODWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.apod.title)
            APODImageView(apod: entry.apod)
        }
        .redacted(reason: entry.apod.title == APODWidgetViewItem.widgetPlaceHolder.title ? .placeholder : [])
    }
}

extension APODItem.APODAsset {
    func image() -> CGImage? {
        print("\(#function)")
        switch self {
        case .video:
            return nil
        case let .image(url):
            do {
                let data = try Data(contentsOfFile: url.lastPathComponent)
                let provider = try data.toCGDataProvider()
                let cgImage = try provider.toCGImage()
                return cgImage
            } catch {
                return nil
            }
        }
    }
}

extension APODItem {
    func mapToWidgetViewItem() -> APODWidgetViewItem? {
        guard let image = self.asset.image() else { return nil }
        return APODWidgetViewItem(title: self.title,
                                  image: image)
    }
}
