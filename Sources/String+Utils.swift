//
//  String+Utils.swift
//  WrapGen
//
//  Created by Harlan Haskins on 1/25/17.
//
//

import Foundation
import Clang

enum Extraction {
    case clang
    case llvm(symbol: String)
    case regex(String)

    var regexPattern: String {
        switch self {
        case .clang:
            return "CX\\w+_(\\w+)"
        case .llvm(let symbol):
            return "\(symbol)(\\w+)"
        case .regex(let pattern):
            return pattern
        }
    }
}

extension String: Error {
    var lowercasingFirstWord: String {
        var wordIndex = startIndex
        let thresholdIndex = index(wordIndex, offsetBy: 1)
        for c in unicodeScalars {
            if islower(Int32(c.value)) != 0 {
                if wordIndex > thresholdIndex {
                    wordIndex = index(before: wordIndex)
                }
                break
            }
            wordIndex = index(after: wordIndex)
        }
        if wordIndex == startIndex {
            return self
        }
        return substring(to: wordIndex).lowercased() + substring(from: wordIndex)
    }

    func extracting(_ extraction: Extraction) -> String {
        return replacingOccurrences(of: extraction.regexPattern,
                                    with: "$1",
                                    options: .regularExpression)
    }

    func wrapped(to columns: Int = 80) -> [String] {
        let scanner = Scanner(string: self)

        var result = [String]()
        var current = ""
        var currentLineLength = 0

        var word: NSString?
        while scanner.scanUpToCharacters(from: .whitespacesAndNewlines,
                                         into: &word), let word = word {
            let wordLength = word.length

            if currentLineLength != 0 && currentLineLength + wordLength + 1 > columns {
                // too long for current line, wrap
                result.append(current)
                current = ""
                currentLineLength = 0
            }

            // append the word
            if currentLineLength != 0 {
                current.append(" ")
                currentLineLength += 1
            }
            current += word as String
            currentLineLength += wordLength
        }

        if !current.isEmpty {
            result.append(current)
        }
        return result
    }
}
