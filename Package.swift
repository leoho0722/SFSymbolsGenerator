// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SFSymbolsGenerator",
    platforms: [.macOS("14.0")],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0")
    ],
    targets: [
        .executableTarget(
            name: "sf-symbols",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/"
        )
    ]
)
