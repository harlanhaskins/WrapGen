cd ..
git clone https://github.com/trill-lang/ClangSwift
cd ClangSwift
swift utils/make-pkgconfig.swift
cd WrapGen
swift build
