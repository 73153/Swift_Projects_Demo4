//
//  CircularQueue.swift
//  CircularQueue
//
//  Created by Andrew Hulsizer on 6/6/14.
//  Copyright (c) 2014 Tastemade. All rights reserved.
//

import Foundation

struct CircularQueue<T> {
    
    var buffer: Dictionary<Int, T>
    var bufferSize: Int
    var currentIndex: Int
    var oldestIndex: Int
    
    init(bufferSize: Int) {
        self.bufferSize = bufferSize
        buffer = Dictionary<Int, T>(minimumCapacity: bufferSize)
        currentIndex = 0
        oldestIndex = 0
    }
    
    mutating func push(element: T) {
        currentIndex = (currentIndex+1)%bufferSize
        buffer[currentIndex] = element
        if currentIndex == oldestIndex {
            oldestIndex = (oldestIndex+1)%bufferSize
        }
    }
    
    mutating func pop() -> T? {
        let item = buffer[oldestIndex]
        buffer[oldestIndex] = nil
        oldestIndex = (oldestIndex+1)%bufferSize
        return item
    }
}

extension CircularQueue: Sequence {
    func generate() -> CircularQueueGenerator<T> {
        var slice = Slice<T>()
        for var index = 0; index < bufferSize; ++index {
            if let value = buffer[(index+oldestIndex)%bufferSize]? {
                slice.append(value)
            }
        }
        return CircularQueueGenerator(items: slice)
    }
}

struct CircularQueueGenerator<T> : Generator {
    
    var items: Slice<T>
    
    mutating func next() -> T? {
        if items.isEmpty {
            return nil;
        }
        let item = items[0]
        items = items[1..items.count]
        return item
    }
}

