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
        self.init(name: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
}

extension Value: IntegerLiteralConvertible {
    init(integerLiteral value: Int) {
        self = .IntValue(int: value)
    }
}
