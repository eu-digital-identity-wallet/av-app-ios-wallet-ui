// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-issuance",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "feature-issuance",
      targets: ["feature-issuance"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test"),
    .package(name: "mrz-reader", path: "./mrz-reader"),
    .package(url: "https://github.com/AndyQ/NFCPassportReader", from: "2.3.0")
  ],
  targets: [
    .target(
      name: "feature-issuance",
      dependencies: [
        "feature-common",
        "mrz-reader",
        .product(name: "NFCPassportReader", package: "NFCPassportReader"),
        "FaceMatchSDK"
      ],
      path: "./Sources",
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "feature-issuance-tests",
      dependencies: [
        "feature-issuance",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests"
    ),
    .binaryTarget(
      name: "FaceMatchSDK",
      path: "../../Frameworks/FaceMatchSDK.xcframework"
    )
  ]
)
