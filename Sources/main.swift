import CommandLineKit
import Clang
import Foundation

enum ExportType: String {
    case `struct` = "struct"
    case `enum` = "enum"
    case optionSet = "options"
}

let cmdLine = CommandLineKit.CommandLine()

let file = StringOption(shortFlag: "f",
                        longFlag: "file",
                        required: true,
                        helpMessage: "The file you're trying to parse")

let symbol = StringOption(shortFlag: "s",
                          longFlag: "symbol",
                          required: true,
                          helpMessage: "The name of the enum you're trying to convert")

let useLLVMPrefix = BoolOption(shortFlag: "l", longFlag: "llvm-prefix",
                               helpMessage: "Use LLVM-style extraction ({name}{case})")
let regexExtraction = StringOption(longFlag: "regex",
                                   helpMessage: "Use a custom extraction regex (must have exactly one capture group)")

let newType = StringOption(shortFlag: "n",
                           longFlag: "name",
                           required: true,
                           helpMessage: "The new name you're trying to generate")

let suffix = StringOption(longFlag: "suffix",
                          required: false,
                          helpMessage: "The suffix to apply to each new object generated")

let exportType = EnumOption<ExportType>(shortFlag: "t",
                                        longFlag: "type",
                                        required: true,
                                        helpMessage: "The type of conversion you're applying")

cmdLine.addOptions(file, symbol, useLLVMPrefix, regexExtraction, newType, suffix, exportType)

do {
    try cmdLine.parse()

    let index = Index()
    let tu = try TranslationUnit(index: index,
                                 filename: file.value!,
                                 commandLineArgs: [
                                    "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include",
                                    "-I/usr/local/opt/llvm/include"
        ])

    guard let enumDecl = tu.findEnum(name: symbol.value!) else {
        throw "Could not find symbol \(symbol.value!)"
    }

    let extraction: Extraction
    if useLLVMPrefix.value {
        extraction = .llvm(symbol: symbol.value!)
    } else if let regex = regexExtraction.value {
        extraction = .regex(regex)
    } else {
        extraction = .clang
    }

    switch exportType.value! {
    case .struct:
        generateStructs(forEnum: enumDecl,
                        type: newType.value!,
                        extraction: extraction,
                        suffix: suffix.value ?? "")
    case .enum:
        generateSwiftEnum(forEnum: enumDecl,
                          enumName: symbol.value!,
                          extraction: extraction,
                          name: newType.value!)
    case .optionSet:
        generateSwiftOptionSet(forEnum: enumDecl,
                               enumName: symbol.value!,
                               extraction: extraction,
                               name: newType.value!)
    }
} catch {
    print("error: \(error)")
    exit(-1)
}
