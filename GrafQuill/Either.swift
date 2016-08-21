//
//  Either.swift
//  GrafQuill
//
//  Created by Matt Fenwick on 8/21/16.
//  Copyright © 2016 mf. All rights reserved.
//

import Foundation

enum Either<A, B> {
    case Left(A)
    case Right(B)
}
