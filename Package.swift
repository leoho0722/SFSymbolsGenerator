// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SFSymbolsGenerator",
    platforms: [.macOS("13.3")],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "SFSymbolsGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ], 
            path: "Sources/"
        ),
    ]
)
