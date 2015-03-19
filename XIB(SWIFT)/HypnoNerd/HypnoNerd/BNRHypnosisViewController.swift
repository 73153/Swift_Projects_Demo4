//
//  BNRHypnosisViewController.swift
//  HypnoNerd
//
//  Created by Han Kang on 6/9/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRHypnosisViewController: UIViewController, UITextFieldDelegate {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "Hypnotize"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = UIScreen.mainScreen().bounds
        let backgroundView = BNRHypnosisView(frame: frame)
        self.view = backgroundView
        let textFieldRect = CGRectMake(40,70,240,30)
        var textField = UITextField(frame:textFieldRect)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Hypnotize me!"
        textField.returnKeyType = UIReturnKeyType.Done
        textField.delegate = self
        backgroundView.addSubview(textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func drawHypnoticMessage(message:NSString) {
        for i in 0...20 {
            var messageLabel = UILabel()
            messageLabel.backgroundColor = UIColor.clearColor()
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.text = message
            messageLabel.sizeToFit()
            var width = self.view.bounds.size.width - messageLabel.bounds.size.height
            
            var x = arc4random() % UInt32(width)//.bridgeToObjectiveC().intValue
            var height = self.view.bounds.size.height - messageLabel.bounds.size.height
            var y = arc4random() % UInt32(height)//.bridgeToObjectiveC().intValue
            var frame = messageLabel.frame
            frame.origin = CGPointMake(CGFloat(x),CGFloat(y))
            messageLabel.frame = frame
            self.view.addSubview(messageLabel)
            var firstMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
            
            firstMotionEffect.minimumRelativeValue = -25
            firstMotionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(firstMotionEffect)
            var motionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                           type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
            
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(motionEffect)
            
            
        }
    }
    
//    func textFiel
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        NSLog("asdfasdfasdf should be returning")
        self.drawHypnoticMessage(textField.text)
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
