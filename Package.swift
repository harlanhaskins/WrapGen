import PackageDescription

let package = Package(
    name: "WrapGen",
    dependencies: [
      .Package(url: "../ClangSwift", majorVersion: 0),
      .Package(url: "https://github.com/harlanhaskins/CommandLine.git", majorVersion: 3)
    ]
)
