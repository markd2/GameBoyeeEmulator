// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "gbee",
    platforms: [
      .macOS(.v15)
    ],
    dependencies: [
      .package(
        url: "https://github.com/apple/swift-argument-parser",
        from: "1.3.0"
      )
    ],
    targets: [
        .executableTarget(
            name: "gbee",
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
    ]
)
