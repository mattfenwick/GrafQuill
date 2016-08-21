//
//  LiteralConvertible.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/18/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation



extension Variable: StringLiteralConvertible {
    init(stringLiteral value: String) {
        try! self.init(name: value)
    }
    init(unicodeScalarLiteral value: String) {
        try! self.init(name: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        try! self.init(name: value)
    }
}

extension Number: IntegerLiteralConvertible {
    init(integerLiteral value: Int) {
        self = Number(int: value, fraction: nil, exponent: nil)
    }
}

extension Value: IntegerLiteralConvertible {
    init(integerLiteral value: Int) {
        self = .Number_(number: Number(int: value, fraction: nil, exponent: nil))
    }
}
