// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-onboarding",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-onboarding",
      targets: ["feature-onboarding"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-onboarding",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-onboarding-tests",
      dependencies: [
        "feature-onboarding",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests")
  ]
)
