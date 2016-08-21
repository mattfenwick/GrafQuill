//
//  Array1.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

struct Array1<T> {
    let x: T
    let xs: [T]
}

extension Array1 {
    func map<U>(@noescape transform: T throws -> U) rethrows -> Array1<U> {
        return Array1<U>(x: try transform(self.x), xs: try self.xs.map(transform))
    }

    func push(t: T) -> Array1<T> {
        return Array1(x: x, xs: xs + [t])
    }
}

// extension Array1: Equatable {}

func ==<T: Equatable>(left: Array1<T>, right: Array1<T>) -> Bool {
    return
        left.x == right.x &&
        left.xs == right.xs
}

extension Array1: CollectionType {
    typealias Generator = AnyGenerator<T>

    var startIndex: Int { return 0 }
    var endIndex: Int { return self.xs.endIndex + 1 }

    subscript(position: Int) -> T {
        if position == 0 {
            return self.x
        }
        return self.xs[position - 1]
    }

    func generate() -> AnyGenerator<T> {
        var index = 0
        return AnyGenerator {
            guard index > 0 else {
                index += 1
                return self.x
            }
            let currentIndex = index - 1
            guard currentIndex < self.xs.count else { return nil }
            index += 1
            return self.xs[currentIndex]
        }
    }
}
