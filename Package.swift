// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-type-name",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
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