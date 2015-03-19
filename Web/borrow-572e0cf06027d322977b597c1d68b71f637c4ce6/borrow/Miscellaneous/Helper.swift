//
//  Helper.swift
//  borrow
//
//  Created by Tobias Tiemerding on 6/8/14.
//
//

import UIKit

class Helper : NSObject {

    class func displayAlertWithTitle(title: String?, andMessage message: String?, inViewController viewController: UIViewController!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
