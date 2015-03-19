//
//  SEPushNoAnimationSegue.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Move to the next screen without an animation.
 */
@objc(SEPushNoAnimationSegue)
class SEPushNoAnimationSegue: UIStoryboardSegue {

    override func perform() {
        self.sourceViewController.navigationController!.pushViewController(self.destinationViewController as UIViewController, animated: false)
    }

}
