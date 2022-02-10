import Foundation
import APODKit
import LoggingKit

open class AppClipController {

    private let dependencies: DependencyInjectionContainer

    public let model: APODModel

    public init() {
        Log.register(logger: ConsoleLogger.instance)
        dependencies = DependencyInjectionContainer()
        model = APODModel(dependencies: dependencies)
    }

    public func openURL(_ url: URL) {
        Log.debug("Opening URL - \(url)")
        // parse url
        let dateString = url.lastPathComponent
        guard let dateFromUrl = ISO8601DateFormatter.fullYearWithDashFormatter.date(from: dateString) else {
            Log.error("Error parsing date from url - \(url)")
            return
        }

        model.date = dateFromUrl
    }
}
