//
//  UIActivityTypeOpenWithSafari.swift
//  borrow
//
//  Created by markus on 08.06.14.
//
//

import UIKit

class UIActivityTypeOpenWithSafari : UIActivity {
    var activityURL = NSURL()
    
    override class func activityCategory() -> UIActivityCategory {
        return UIActivityCategory.Share
    }
    
    override func activityTitle() -> String! {
        return NSLocalizedString("Safari", comment: "")
    }
    
    override func activityImage() -> UIImage! {
        return UIImage(named: "UIActivityTypeOpenInSafari")
    }
    
    override func canPerformWithActivityItems(activityItems: AnyObject[]!) -> Bool{
        if activityItems.count == 1 && activityItems[0] is NSURL {
            return true
        } else {
            return false
        }
    }
    
    override func prepareWithActivityItems(activityItems: AnyObject[]!) {
        activityURL = activityItems[0] as NSURL;
    }
    
    override func performActivity() {
        UIApplication.sharedApplication().openURL(activityURL)
        self.activityDidFinish(true)
    }
}