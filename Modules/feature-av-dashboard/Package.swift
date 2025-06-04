// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-av-dashboard",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-av-dashboard",
      targets: ["feature-av-dashboard"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-av-dashboard",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    )
  ]
)
