// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "leprechaun",
    dependencies: [
      .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
    ],
    targets: [
      .target(
          name: "leprechaun",
          dependencies: [
            "SwiftSoup",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
          ]),
      .testTarget(
          name: "r6scraperTests",
          dependencies: ["leprechaun"]),
    ]
)
