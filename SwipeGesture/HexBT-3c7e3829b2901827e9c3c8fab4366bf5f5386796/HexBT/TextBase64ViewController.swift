//
//  TextBase64ViewController.swift
//  HexBT
//
//  Created by Pan Ziyue on 12/6/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

import UIKit

class TextBase64ViewController: UITableViewController {
    
    // Variables here
    @IBOutlet var textToBase64 : GCPlaceholderTextView
    @IBOutlet var base64Disp : GCPlaceholderTextView

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

        textToBase64.placeholder = "Input text here"
        base64Disp.placeholder = "Output Base64 here"
        
        // Set title text attributes
        var title = UILabel(frame: CGRectMake(0, 0, 400, 44))
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.whiteColor()
        title.text = "Text to Base64 Converter"
        title.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        self.navigationItem.titleView = title
        
        // Set background attributes
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // Setup gesture actions
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func convert(sender:AnyObject) {
        /*
        if ([plainText length] == 0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error: Invalid or no text!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        textToBase64.text=@"";
        }
        */
        if textToBase64.hasText() {
            base64Disp.text = CommonObjCMethods.base64Encode(textToBase64.text)
            textToBase64.resignFirstResponder()
        } else if !base64Disp.hasText() || (!textToBase64.hasText()){
            SVProgressHUD.showErrorWithStatus("Error: Invalid or no text!")
            textToBase64.resignFirstResponder()
        } else {
            textToBase64.resignFirstResponder()
        }
    }
    
    @IBAction func share(sender:AnyObject) {
        if base64Disp.hasText() {
            let base64String : String = base64Disp.text
            SVProgressHUD.showWithStatus("Loading...")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                let actViewCtrl = UIActivityViewController(activityItems: [base64String], applicationActivities: nil)
                self.presentViewController(actViewCtrl, animated: true, completion: {SVProgressHUD.dismiss()})
                })
        } else {
            SVProgressHUD.showErrorWithStatus("Nothing to share!")
        }
    }
    
    func dismissKeyboard() {
        textToBase64.resignFirstResponder()
        base64Disp.resignFirstResponder()
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
