// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-assembly",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-assembly",
      targets: ["logic-assembly"]
    )
  ],
  dependencies: [
    .package(name: "feature-common", path: "../feature-common"),
    .package(name: "feature-startup", path: "../feature-startup"),
    .package(name: "feature-presentation", path: "../feature-presentation"),
    .package(name: "feature-issuance", path: "../feature-issuance"),
    .package(name: "feature-onboarding", path: "../feature-onboarding"),
    .package(name: "feature-av-dashboard", path: "../feature-av-dashboard")
  ],
  targets: [
    .target(
      name: "logic-assembly",
      dependencies: [
        "feature-common",
        "feature-startup",
        "feature-presentation",
        "feature-issuance",
        "feature-onboarding",
        "feature-av-dashboard"
      ],
      path: "./Sources"
    )
  ]
)
