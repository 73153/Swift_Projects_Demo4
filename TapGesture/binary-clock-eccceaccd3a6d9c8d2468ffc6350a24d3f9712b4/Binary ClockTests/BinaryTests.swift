//
//  BinaryTests.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 06.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import XCTest

class BinaryTests: XCTestCase {
   
    func testUInt8Binary() {
        let input = UInt8(5)
        let output = input.binary
        let expected = [false, false, false, false, false, true, false, true]
        
        XCTAssert(output == expected, "\(input).binary should be \(expected), but is \(output)");
    }

}
