/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                Adds a category to NSColor to provudes predefined incomplete and complete item text color.
            
*/

import Cocoa

extension NSColor {
    struct SharedColors {
        static let completeItemTextColor = NSColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1)
    }

    class func completeItemTextColor() -> NSColor {
        return SharedColors.completeItemTextColor
    }
    
    class func incompleteItemTextColor() -> NSColor {
        return NSColor.blackColor()
    }
}