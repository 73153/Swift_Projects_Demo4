//
//  TextHexViewController.swift
//  HexBT
//
//  Created by Pan Ziyue on 11/6/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

import UIKit

class TextHexViewController: UITableViewController {
    
    // Variables here
    @IBOutlet var textToHex : GCPlaceholderTextView
    @IBOutlet var hexDisp : GCPlaceholderTextView

    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textToHex.placeholder = "Input text here"
        hexDisp.placeholder = "Output hexadecimal here"
        
        // Set background colors
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // Set title text attributes
        var label = UILabel(frame: CGRectMake(0, 0, 400, 44))
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.text = "Text to Hexadecimal Converter"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        self.navigationItem.titleView = label;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func convert(sender:AnyObject) {
        if textViewHasText(textToHex) {
            hexDisp.text = CommonObjCMethods.textToHex(textToHex.text)
            textToHex.resignFirstResponder()
        } /*else if hexDisp.hasText()||(!textToHex.hasText()) {
            SVProgressHUD.showErrorWithStatus("Error: Invalid or no text!")
            hexDisp.text = ""
            textToHex.resignFirstResponder()
        }*/ else {
            SVProgressHUD.showErrorWithStatus("Error: Invalid or no text!")
            textToHex.resignFirstResponder()
        }
    }
    
    @IBAction func share(sender:AnyObject) {
        if textViewHasText(hexDisp) {
            let hexString : String = hexDisp.text
            SVProgressHUD.showWithStatus("Loading...")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                var actViewCtrl = UIActivityViewController(activityItems: [hexString], applicationActivities: nil)
                self.presentViewController(actViewCtrl, animated: true, completion: {SVProgressHUD.dismiss()})
                })
        } else {
            SVProgressHUD.showErrorWithStatus("Nothing to share!")
        }
    }
    
    func dismissKeyboard() {
        textToHex.resignFirstResponder()
        hexDisp.resignFirstResponder()
    }
    
    func textViewHasText (textView : UITextView) -> (Bool) {
        if textView.text.utf16count > 0 {
            return true
        } else {
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
