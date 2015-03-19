//
//  BinaryClockTests.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 05.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import XCTest

class BinaryClockTests: XCTestCase {
    
    var binClock = BinaryClock()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSplitDigits() {
        let input  = 31
        let output = BinaryClock.splitDigits(input)
        let expected = [
            UInt8(3),
            UInt8(1)
        ]

        XCTAssert(output == expected, "splitDigits(\(input)) should be \(expected), but it is \(output)")
    }
    
    // TODO: Test seconds
    func testTime() {
        // Get date and time close together
        let time = binClock.time
        var date = NSDate();
        
        // Get current date
        let timeZoneSeconds = NSTimeInterval(NSTimeZone.localTimeZone().secondsFromGMT)
        date.dateByAddingTimeInterval(timeZoneSeconds)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "H:m" // :s
        
        let output = "\(time.0):\(time.1)"
        let expected = dateFormatter.stringFromDate(date)
        
        XCTAssert(output == expected, "time should be (\(expected)), but is (\(output))")
    }

}
