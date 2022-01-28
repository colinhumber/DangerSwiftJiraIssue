// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerSwiftJiraIssue",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "DangerSwiftJiraIssue", targets: ["DangerSwiftJiraIssue"]),
//        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]) // dev
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift", from: "3.0.0"),
//        .package(url: "https://github.com/f-meloni/Rocket", from: "1.0.0"), // dev,
    ],
    targets: [
//        .target(name: "DangerDependencies", dependencies: [.product(name: "Danger", package: "swift"), "DangerSwiftJiraIssue"]), // dev
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DangerSwiftJiraIssue",
            dependencies: [
                .product(name: "Danger", package: "swift")
            ]
        ),
        .testTarget(
            name: "DangerSwiftJiraIssueTests",
            dependencies: [
                "DangerSwiftJiraIssue"
            ]
        ),
    ]
)
