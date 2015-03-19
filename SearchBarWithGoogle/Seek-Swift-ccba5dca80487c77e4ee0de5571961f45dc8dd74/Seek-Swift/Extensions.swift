//
//  Extensions.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/9/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension String {
    func escape() -> String {
        return self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }
}

extension NSError {
    class func cancelledRequestCode() -> Int { return -999 }
    
    class func noResultsFoundError() -> NSError {
        let errorDomain = "com.jmesmith.seek-swift"
            return NSError(domain: errorDomain, code: 0,
                userInfo: [ "Description": "No Results Found" ])
        }
}