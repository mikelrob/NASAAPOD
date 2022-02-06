import Foundation

public struct APODStorageItem: Codable {
    public enum Asset: Codable {
        case video(URL)
        case image(remote: URL, local: URL?)
    }

    public let date: String
    public let title: String
    public let explanation: String
    public let asset: Asset
}
