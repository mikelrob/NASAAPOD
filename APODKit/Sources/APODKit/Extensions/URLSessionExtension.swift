import Foundation

public protocol URLSessionType {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    func dataTask(with url: URL) async throws  -> (Data, URLResponse)
//    func downloadTask(with url: URL, to path: String) async throws  -> (URL, URLResponse)
}

extension URLSession: URLSessionType {
    public func dataTask(with url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let data = data, let response = response else {
                        return continuation.resume(throwing: URLError(.badServerResponse))
                    }
                    continuation.resume(returning: (data, response))
                }
            }.resume()
        }
    }
}
