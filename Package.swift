// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Crystal",
    platforms: [.iOS(.v10), .macOS(.v10_12)],
    products: [
        .library(
            name: "Crystal",
            targets: ["Crystal"]
        ),
    ],
    targets: [
        .target(
            name: "Crystal",
            path: "Sources"
        ),
        .testTarget(
            name: "CrystalTests",
            dependencies: ["Crystal"],
            path: "Tests"
        ),
    ]
)
