// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "audio-unit-filter-demo",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "FilterDemo",
            targets: ["FilterDemo"]
        ),
        .library(
            name: "SimplePlayEngine",
            targets: ["SimplePlayEngine"]
        ),
        .library(
            name: "AudioUnit",
            targets: ["AudioUnit", "AudioUnitObjC"]
        ),
        .library(
            name: "FilterView",
            targets: ["FilterView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.18.0"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "FilterDemo",
                "SimplePlayEngine",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .target(
            name: "FilterDemo",
            dependencies: [
                "AudioUnit",
                "FilterView",
                "SimplePlayEngine"
            ]
        ),
        .target(
            name: "SimplePlayEngine",
            dependencies: [],
            resources: [.process("Audio/")]
        ),
        .target(
            name: "AudioUnit",
            dependencies: ["AudioUnitObjC"],
            path: "Sources/Swift"
        ),
        .target(
            name: "AudioUnitObjC",
            dependencies: [],
            path: "Sources/ObjC"
        ),
        .target(
            name: "FilterView",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        )
    ]
)
