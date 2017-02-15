//
//  Generate.swift
//  WrapGen
//
//  Created by Harlan Haskins on 1/25/17.
//
//

import Clang
import Foundation

func generateSwiftOptionSet(forEnum decl: EnumDecl, enumName: String,
                            extraction: Extraction, name: String) {
    if let comment = decl.fullComment {
        for line in convert(comment) {
            print(line)
        }
    }
    print("public struct \(name): OptionSet {")
    print("  public typealias RawValue = \(enumName).RawValue")
    print("  public let rawValue: RawValue")
    print("  /// Creates a new \(name) from a raw integer value.")
    print("  public init(rawValue: RawValue) {")
    print("    self.rawValue = rawValue")
    print("  }")
    for constant in decl.constants() {
        if let comment = constant.fullComment {
            print()
            for line in convert(comment, indent: 2) {
                print("  \(line)")
            }
        }
        let constName = "\(constant)".extracting(extraction)
                                     .lowercasingFirstWord
        print("  public static let \(constName) = \(name)(rawValue: ")
        print("    \(constant).rawValue)")
    }
    print("}")
}

func generateSwiftEnum(forEnum decl: EnumDecl, enumName: String,
                       extraction: Extraction, name: String) {
    var pairs = [(String, String, EnumConstantDecl)]()
    if let comment = decl.fullComment {
        for line in convert(comment) {
            print(line)
        }
    }
    print("public enum \(name) {")
    for child in decl.constants() {
        let constantName = "\(child)"
        let name = constantName.extracting(extraction)
                               .lowercasingFirstWord
        pairs.append((constantName, name, child))
    }
    for (_, name, decl) in pairs {
        if let comment = decl.fullComment {
            print()
            for section in convert(comment, indent: 2) {
                print("  \(section)")
            }
        }
        print("  case \(name)")
    }
    print()
    print("  init(clang: \(enumName)) {")
    print("    switch clang {")
    for (constant, name, _) in pairs {
        print("    case \(constant): self = .\(name)")
    }
    print("    default: fatalError(\"invalid \(enumName) \\(clang)\")")
    print("    }")
    print("  }")
    print("}")
}

func generateStructs(forEnum decl: EnumDecl,
                     type: String,
                     extraction: Extraction,
                     suffix: String = "") {
    let protocolDecl = [
        "public protocol \(type) {",
        "  var clang: CX\(type) { get }",
        "}",
        ""
        ].joined(separator: "\n")
    var structDecls = [String]()
    var conversionCases = [String]()
    for child in decl.constants() {
        let typeName = "\(child)".extracting(extraction)
        if typeName.hasPrefix("First") || typeName.hasPrefix("Last") { continue }
        let structName = "\(typeName)\(suffix)"
        var pieces = [
            "public struct \(structName): \(type) {",
            "  let clang: CX\(type)",
            "}",
            ""
        ]
        if let comment = child.fullComment {
            pieces.insert(contentsOf: convert(comment), at: 0)
        }
        structDecls.append(pieces.joined(separator: "\n"))
        conversionCases.append("case \(child): return \(structName)(clang: clang)")
    }

    print(protocolDecl)
    for structDecl in structDecls {
        print(structDecl)
    }
    print("/// Converts a CX\(type) to a \(type), returning `nil` if it was " +
        "unsuccessful")
    print("func convert\(type)(_ clang: CX\(type)) -> \(type)? {")
    print("  if <#clang thing is null?#> { return nil }")
    print("  switch <#Get clang kind#> {")
    for caseDecl in conversionCases {
        print("  \(caseDecl)")
    }
    print("  default: fatalError(\"invalid CX\(type)Kind \\(clang)\")")
    print("  }")
    print("}")
}
