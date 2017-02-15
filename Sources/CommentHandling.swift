//
//  CommentHandling.swift
//  WrapGen
//
//  Created by Harlan Haskins on 1/25/17.
//
//

import Foundation
import Clang

/// Performs a BFS over the comment text and converts it into Swift-compatible
/// comments. Very quick&dirty, and will require manual edits.
func convert(_ comment: FullComment, indent: Int = 0) -> [String] {
    var sections = [String]()
    var queue = [Comment]()
    queue.append(comment)
    while !queue.isEmpty {
        let next = queue.removeFirst()
        if let para = next as? ParagraphComment {
            if let textChildren = Array(para.children) as? [TextComment] {
                let text = textChildren.map { $0.text }.joined()
                sections.append(contentsOf: text.wrapped(to: 76 - indent))
                continue
            }
        } else if let textComment = next as? TextComment {
            sections.append(contentsOf: textComment.text.wrapped(to: 76 - indent))
        } else if let line = next as? VerbatimLineComment {
            sections.append("`\(line.text)`")
        } else if let line = next as? InlineCommandComment {
            let args = Array(line.arguments)
            if !args.isEmpty {
                sections.append("`\(args[0])`")
            }
        } else if let block = next as? VerbatimBlockCommandComment {
            sections.append("```")
            for child in block.children {
                guard let verbatim = child as? VerbatimBlockLineComment else { continue }
                sections.append(verbatim.text)
            }
            sections.append("```")
        } else if
            // Check if we've got a brief declaration that's
            // got text inside it, and it put before anything else.
            let brief = next as? BlockCommandComment,
            brief.name == "brief",
            let para = brief.firstChild as? ParagraphComment,
            let text = Array(para.children) as? [TextComment] {
            let paraText = text.map { $0.text }.joined(separator: "")
            let textSections = paraText.wrapped(to: 76 - indent)
            sections.insert(contentsOf: textSections, at: 0)
            queue.append(contentsOf: brief.children.dropFirst())
            continue
        }
        queue.append(contentsOf: next.children)
    }
    return sections.lazy
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
        .map { "/// \($0)" }
}
