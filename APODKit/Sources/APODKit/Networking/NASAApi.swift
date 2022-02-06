import Foundation
import Moya

public enum NASAApi: TargetType {

    static let apiKey = "6A4ArTfcNfEhNqR9W4QdbKfgHIB6pYR3V61BWLWk"
    case apod(date: Date)

    // swiftlint:disable force_unwrapping
    public var baseURL: URL { return URL(string: "https://api.nasa.gov")! }
    // swiftlint:enable force_unwrapping

    public var path: String {
        switch self {
        case .apod:
            return "/planetary/apod"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .apod:
            return .get
        }
    }

    public var task: Task {
        var params = ["api_key": NASAApi.apiKey]
        switch self {
        case let .apod(date):
            params["date"] = ISO8601DateFormatter.fullYearWithDashFormatter.string(from: date)
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
