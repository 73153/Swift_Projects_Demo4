//
//  SENoStatusBarImagePickerController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-14.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Image picker view controller subclass with hidden status bar.
 */
class SENoStatusBarImagePickerController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefersStatusBarHidden()
        
        if self.respondsToSelector("setNeedsStatusBarAppearanceUpdate") {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func childViewControllerForStatusBarHidden() -> UIViewController! {
        return nil
    }

}
