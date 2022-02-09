// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "APODAppClip",
    platforms: [.iOS(.v14) ],
    products: [
        .library(
            name: "APODAppClip",
            targets: ["APODAppClip"]),
        .library(
            name: "APODApp",
            targets: ["APODApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mikelrob/logging", from: "0.1.0"),
        .package(path: "../APODKit"),
    ],
    targets: [
        .target(
            name: "APODAppClip",
            dependencies: [
                "APODKit",
                .product(name: "LoggingKit", package: "logging"),
            ]),
        .testTarget(
            name: "APODAppClipTests",
            dependencies: ["APODAppClip"]),
        .target(
            name: "APODApp",
            dependencies: [
                "APODAppClip",
                .product(name: "LoggingKit", package: "logging"),
            ]),
        .testTarget(
            name: "APODAppTests",
            dependencies: ["APODApp"]),
    ]
)
