//
//  Binary.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 05.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import Foundation

// Protocol for binary values
protocol Binary {
    
    var binary: Bool[] { get }
    
}

// Extend UInt8 to get binary value
extension UInt8: Binary {
    
    var binary: Bool[] {
        var bit  = UInt8.max
        var bin  = Bool[]()
        var rest = self
        
        do {
            bit >>= 1 // Shift to the left
            
            var current = false
            
            if rest >= bit + 1 {
                rest   -= bit + 1
                current = true
            }
            
            bin.append(current)
        } while bit > 0
        
        return bin
    }
    
}

