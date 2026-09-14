// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BlockData",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BlockData",
            targets: ["BlockData"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BlockData",
            dependencies: [],
            path: "Sources/BlockData",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
