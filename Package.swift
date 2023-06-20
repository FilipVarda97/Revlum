// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Revlum",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Revlum",
            targets: ["Revlum"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Revlum",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RevlumTests",
            dependencies: ["Revlum"]),
    ]
)
