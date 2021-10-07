// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaskManager",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "TaskManager",
            targets: ["TaskManager"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TaskManager",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "TaskManagerTests",
            dependencies: ["TaskManager"]
        )
    ]
)
