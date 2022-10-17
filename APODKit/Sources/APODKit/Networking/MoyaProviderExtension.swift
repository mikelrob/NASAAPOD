import Foundation
import Moya

extension MoyaProvider {
    func request(_ target: Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none) async throws -> Moya.Response {
        let response: Moya.Response = try await withCheckedThrowingContinuation { continuation in
            request(target, callbackQueue: callbackQueue, progress: progress) { result in
                continuation.resume(with: result)
            }
        }
        return response
    }
}
