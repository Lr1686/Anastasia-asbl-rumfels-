// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Janus",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Janus",
            targets: ["Janus"]
        ),
    ],
    targets: [
        .target(
            name: "Janus",
            dependencies: []
        ),
        .testTarget(
            name: "JanusTests",
            dependencies: ["Janus"]
        ),
    ]
)
