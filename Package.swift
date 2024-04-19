// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureFlags",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FeatureFlags",
            targets: ["FeatureFlags"]
        ),
        .library(
            name: "FeatureFlagsUI",
            targets: ["FeatureFlagsUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/iwill/generic-json-swift", from: "2.0.0"),
        .package(url: "https://github.com/AliSoftware/Reusable", from: "4.1.2"),
    ],
    targets: [
        .target(
            name: "FeatureFlags",
            dependencies: [
                .product(name: "GenericJSON", package: "generic-json-swift"),
            ]
        ),
        .target(
            name: "FeatureFlagsUI",
            dependencies: [
                .target(name: "FeatureFlags"),
                .product(name: "Reusable", package: "Reusable"),
            ]
        ),
        .testTarget(
            name: "FeatureFlagsTests",
            dependencies: ["FeatureFlags"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
