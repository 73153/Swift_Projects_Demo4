//
//  Shape.swift
//  MathKit
//
//  Created by Robert Dimitrov on 6/15/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

import Foundation

protocol Shape {
    func area() -> Float
    func containsPoint(point: Point) -> Bool
}
