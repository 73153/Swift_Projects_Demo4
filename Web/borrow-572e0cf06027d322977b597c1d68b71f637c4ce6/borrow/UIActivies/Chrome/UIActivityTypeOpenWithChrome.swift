//
//  UIActivityTypeOpenWithChrome.swift
//  borrow
//
//  Created by Tobias Tiemerding on 6/8/14.
//
//

import UIKit

class UIActivityTypeOpenWithChrome : UIActivity {
    
    var activityURL = NSURL()
    
    override class func activityCategory() -> UIActivityCategory {
        return UIActivityCategory.Share
    }
    
    override func activityTitle() -> String! {
        return NSLocalizedString("Chrome", comment: "")
    }
    
    override func activityImage() -> UIImage! {
        return UIImage(named: "UIActivityTypeOpenInChrome")
    }
    
    override func canPerformWithActivityItems(activityItems: AnyObject[]!) -> Bool{
        if(!UIApplication.sharedApplication().canOpenURL(NSURL(string: "googlechrome://"))){
            return false
        }
        
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
        let scheme = activityURL.scheme;
        
        var chromeScheme: NSString?
        if (scheme == "http") {
            chromeScheme = "googlechrome"
        } else if (scheme == "https") {
            chromeScheme = "googlechromes"
        }
        
        if let scheme = chromeScheme {
            let URLabsoluteString = activityURL.absoluteString
            let URLwithoutScheme = URLabsoluteString.stringByReplacingOccurrencesOfString(activityURL.scheme, withString: "")
            let URLforChrome = NSURL(string: scheme + URLwithoutScheme)
            
            UIApplication.sharedApplication().openURL(URLforChrome)
            self.activityDidFinish(true)
        } else {
            self.activityDidFinish(false)
        }
    }
}