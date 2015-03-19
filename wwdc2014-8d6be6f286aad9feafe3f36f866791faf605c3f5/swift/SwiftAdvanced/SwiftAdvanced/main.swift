//
//  main.swift
//  SwiftAdvanced
//
//  Created by llv22 on 6/16/14.
//  Copyright (c) 2014 llv22. All rights reserved.
//

import Foundation

func memoize<T: Hashable, U>( body: ((T)->U, T)->U ) -> (T)->U {
    var memo = Dictionary<T, U>()
    return { x in
        if let q = memo[x] { return q }
        let r = body(x)
        memo[x] = r
        return r
    }
}

let fibonacci: (Int)->Double = memoize{
    fibonacci, n in
    n < 2 ? Double(n) : fibonacci(n-2) + fibonacci(n-1)
}

fibonacci(10)