import Foundation

extension JSONDecoder {
    @available(macOS 10.12, *)
    static let apodDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = ISO8601DateFormatter.fullYearWithDashFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unrecognised date format")
            }
            return date
        })
        return jsonDecoder
    }()
}
