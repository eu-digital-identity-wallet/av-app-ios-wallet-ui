// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-api",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "logic-api",
      targets: ["logic-api"])
  ],
  dependencies: [
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-analytics",
      path: "./logic-analytics"
    ),
    .package(
      name: "logic-resources",
      path: "./logic-resources"
    ),
    .package(name: "logic-test", path: "./logic-test"),
    .package(url: "https://github.com/datatheorem/TrustKit", from: "3.0.4")
  ],
  targets: [
    .target(
      name: "logic-api",
      dependencies: [
        "logic-business",
        "logic-analytics",
        "logic-resources",
        .product(name: "TrustKit", package: "TrustKit")
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-api-tests",
      dependencies: [
        "logic-api",
        "logic-analytics",
        "logic-business",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
