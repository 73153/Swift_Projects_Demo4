//
//  BinaryClock.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 05.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import Foundation

class BinaryClock {
    
    var digits: UInt8[] {
        let currentTime = BinaryClock.time()
        
        return BinaryClock.splitDigits(Int(currentTime.0))
            + BinaryClock.splitDigits(Int(currentTime.1))
            + BinaryClock.splitDigits(Int(currentTime.2))
    }
    
    var matrix: Bool[][] {
    let binary = digits.map({ $0.binary })
        
        // FIXME: Make this automated, this is just stupid
        var map = [
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false],
            [false, false, false, false, false, false]
        ]
        
        // Rotate
        for i in 0..binary.count {
            for j in 0..binary[i].count {
                map[j][i] = binary[i][j]
            }
        }
        
        // We only need the lower 4 bits
        for _ in 0..4 { map.removeAtIndex(0) }
        
        return map
    }

    // Returns hours, minutes and seonds in a tuple
    class func time() -> (UInt8, UInt8, UInt8) {
        // Get current date
        var date = NSDate()
        let timeZoneSeconds = NSTimeInterval(NSTimeZone.localTimeZone().secondsFromGMT)
        date.dateByAddingTimeInterval(timeZoneSeconds);
        
        // Get date from tonight at 0:00
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.dateFromString(dateFormatter.stringFromDate(date))
        
        // Get seconds of today
        let secondsToday = Int(date.timeIntervalSince1970 - today.timeIntervalSince1970)
        
        // Get hours
        let hours = Int(secondsToday / 60 / 60)
        
        // Get minutes
        var secondsLeft = secondsToday - hours * 60 * 60
        let minutes = Int(secondsLeft / 60)
        
        // Get seconds
        secondsLeft -= Int(minutes * 60)
        
        return (UInt8(hours), UInt8(minutes), UInt8(secondsLeft))
    }
    
    class func splitDigits(number: Int, width: Int = 2) -> UInt8[] {
        var values = UInt8[]()
        
        // Split into digits
        for var tmpNumber = number;
            tmpNumber > 0;
            tmpNumber = Int(tmpNumber / 10) {
                values.append(UInt8(tmpNumber % 10))
        }
        
        // Check width
        if values.count > width {
            for _ in 0..values.count - width {
                // Remove highest bit(s)
                values.removeAtIndex(0)
            }
        } else if width > values.count {
            for _ in 0..width - values.count {
                // Add bit
                values.append(UInt8(0))
            }
        }
        
        // Reverse array, because we append the digits
        values = values.reverse()
        
        return values
    }
    
    func print() {
        for row in matrix {
            var line = ""
            
            for value in row {
                line += value ? "◼️" : "◻️"
            }
            
            println(line)
        }
    }
    
}
