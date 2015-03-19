//
//  Rectangle.swift
//  MathKit
//
//  Created by Robert Dimitrov on 6/15/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

class Rectangle: Shape {
    var origin: Point, width: Float, height: Float
    
    init(origin: Point, width: Float, height: Float) {
        self.origin = origin
        self.width = height
        self.height = height
    }
    
    func area() -> Float {
        return width * height;
    }
    
    func containsPoint(point: Point) -> Bool {
        return (point.x > origin.x && point.x < origin.x + width) &&
            (point.y > origin.y && point.y < origin.y + height)
    }
}
