// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "APODKit",
    platforms: [.iOS(.v14),
                .macOS(.v12)],
    products: [
        .library(
            name: "APODKit",
            targets: ["APODKit"]),
        .executable(name: "apod",
                    targets: ["APODCLI"])
    ],
    dependencies: [
        .package(name: "Moya", url: "https://github.com/Moya/Moya", from: "15.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
        .package(url: "https://github.com/Quick/Quick", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.0.0"),

    ],
    targets: [
        .target(
            name: "APODKit",
            dependencies: ["Moya"]),
        .testTarget(
            name: "APODKitTests",
            dependencies: [
                "APODKit",
                "Quick",
                "Nimble"
            ],
            resources: [ .copy("Resources") ]),
        .executableTarget(name: "APODCLI",
                          dependencies: [ .product(name: "ArgumentParser", package: "swift-argument-parser"),
                                          "APODKit"]
                         )
    ]
)
