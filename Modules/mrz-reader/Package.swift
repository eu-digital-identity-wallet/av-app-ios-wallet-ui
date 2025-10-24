// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mrz-reader",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "mrz-reader",
            targets: ["mrz-reader"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "mrz-reader",
            dependencies: [],
            path: "./Sources"
        ),
        .testTarget(
            name: "mrz-reader-tests",
            dependencies: ["mrz-reader"],
            path: "./Tests"
        )
    ]
)
