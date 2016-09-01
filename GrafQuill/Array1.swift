//
//  Array1.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/17/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

class Array1<T> {
    private let x: T
    private let xs: [T]
    lazy var elements: [T] = {
        return [self.x] + self.xs
    }()

    init(x: T, xs: [T]) {
        self.x = x
        self.xs = xs
    }
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
//    typealias Generator = AnyGenerator<T> // TODO does this do anything?

    var startIndex: Int { return 0 }
    var endIndex: Int { return self.elements.endIndex }

    subscript(position: Int) -> T {
        return self.elements[position]
    }

    /* why can't you do this?
    func generate() -> IndexingGenerator<Array1> {
        return self.elements.generate()
    }
 */

    func generate() -> AnyGenerator<T> {
        var index = 0
        return AnyGenerator {
            let currentIndex = index
            guard currentIndex < self.elements.count else { return nil }
            index += 1
            return self.elements[currentIndex]
        }
    }
}

func array1Tests() {
    let arr = Array1<Int>(x: 13, xs: [1, 8, 17])
    let out = [arr[2], arr[0], arr[3], arr[1]]
    print("\(arr.elements) \(out) [8, 13, 17, 1]")
    for e in arr {
        print("e: \(e)")
    }
}
