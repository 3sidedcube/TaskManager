// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Task",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "Task",
            targets: ["Task"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Task",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "TaskTests",
            dependencies: ["Task"]
        )
    ]
)
