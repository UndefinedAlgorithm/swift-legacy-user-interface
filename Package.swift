// swift-tools-version:5.2

import PackageDescription

let targets: [Target] = [
  .target(name: "Misc"),
  .target(name: "Wrappers", dependencies: ["Misc"]),
  .target(name: "Layout", dependencies: ["Wrappers"]),
  .target(name: "LegacyUI", dependencies: ["Layout", "Wrappers"]),
]

targets.forEach { target in
  target.swiftSettings = [
    .define("RELEASE", .when(configuration: .release)),
    .define("DEBUG", .when(configuration: .debug))
  ]
}

let testTargets: [Target] = [
//  .testTarget(name: "MiscTests", dependencies: ["Misc"]),
  .testTarget(name: "WrappersTests", dependencies: ["Wrappers"]),
  .testTarget(name: "LayoutTests", dependencies: ["Layout"]),
//  .testTarget(name: "LegacyUITests", dependencies: ["LegacyUI"])
]

let package = Package(
  name: "LegacyUI",
  platforms: [.iOS(.v10)],
  products: [
    .library(name: "Layout", targets: ["Layout"]),
    .library(name: "LegacyUI", targets: ["LegacyUI"])
  ],
  dependencies: [],
  targets: targets + testTargets
)
