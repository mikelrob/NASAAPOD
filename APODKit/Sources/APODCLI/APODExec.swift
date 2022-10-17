import Foundation
import APODKit

enum APODExecError: Error {
    case invalidDateFormat
}

class APODExec {

    private let dependencies = DependencyInjectionContainer()
    private let apodStore: APODStore

    init() {
        apodStore = APODStore(dependencies: dependencies)
    }

    func apodString(for dateString: String) async throws -> String {
        guard let date = ISO8601DateFormatter.fullYearWithDashFormatter.date(from: dateString) else {
            throw APODExecError.invalidDateFormat
        }
        let apodInfo = try await apodStore.apod(for: date)
        return apodInfo.formatForCLI()
    }
}
