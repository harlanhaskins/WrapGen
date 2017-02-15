//
//  TranslationUnit+Lookup.swift
//  WrapGen
//
//  Created by Harlan Haskins on 1/25/17.
//
//

import Foundation
import Clang

extension TranslationUnit {
    func allEnums() -> [(EnumDecl, String)] {
        var decls = [(EnumDecl, String)]()

        for child in cursor.children() {
            if let enumDecl = child as? EnumDecl {
                decls.append((enumDecl, "enum \(enumDecl)"))
            } else if let decl = child as? TypedefDecl,
                let underlying = decl.underlying,
                let enumDecl = underlying.declaration as? EnumDecl{
                decls.append((enumDecl, "\(underlying)"))
            }
        }
        return decls
    }
    func findEnum(name: String) -> EnumDecl? {
        for child in cursor.children() {
            if let enumDecl = child as? EnumDecl, "\(enumDecl)" == name {
                return enumDecl
            }
            if let decl = child as? TypedefDecl,
                let underlying = decl.underlying,
                "\(underlying)" == "enum \(name)" {
                return underlying.declaration as? EnumDecl
            }
        }
        return nil
    }
}
