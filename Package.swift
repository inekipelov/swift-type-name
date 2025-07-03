// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-type-name",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "TypeName",
            targets: ["TypeName"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TypeName",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "TypeNameTests",
            dependencies: ["TypeName"],
            path: "Tests"),
    ]
)