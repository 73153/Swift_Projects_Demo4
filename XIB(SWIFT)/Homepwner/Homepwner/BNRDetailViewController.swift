//
//  BNRDetailViewController.swift
//  Homepwner
//
//  Created by Han Kang on 6/11/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDetailViewController: UIViewController,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UITextFieldDelegate, UIPopoverControllerDelegate {

    class var dateFormatter:NSDateFormatter {
        get {
            GlobalDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            GlobalDateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            return GlobalDateFormatter
        }
    }
    
    var _item:BNRItem?
    var item:BNRItem {
        get {
            return self._item!
        }
        set(item) {
            self._item = item
            self.navigationItem!.title = self.item.itemName
        }
    }
    var imagePickerPopover:UIPopoverController?
    var dismissBlock: () -> Void
    @IBOutlet var nameField : UITextField
    @IBOutlet var serialNumberField : UITextField
    @IBOutlet var valueField : UITextField
    @IBOutlet var dateLabel : UILabel
    @IBOutlet var imageView : UIImageView
    @IBOutlet var toolbar : UIToolbar
    @IBOutlet var cameraButton : UIBarButtonItem
    
    @IBAction func backgroundTapped(sender : AnyObject) {
        self.view.endEditing(true)
    }
    @IBAction func takePicture(sender : AnyObject) {
        if self.imagePickerPopover && self.imagePickerPopover!.popoverVisible {
            self.imagePickerPopover!.dismissPopoverAnimated(true)
            self.imagePickerPopover = nil
            return
        }
        let imagePicker = UIImagePickerController()
        let cameraSourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(cameraSourceType) {
            imagePicker.sourceType = cameraSourceType
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        imagePicker.delegate = self
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.imagePickerPopover = UIPopoverController(contentViewController: imagePicker)
            self.imagePickerPopover!.delegate = self
    
            self.imagePickerPopover!.presentPopoverFromBarButtonItem(sender as UIBarButtonItem,
                    permittedArrowDirections: UIPopoverArrowDirection.Any,
                    animated: true)
        } else {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    init() {
        self.dismissBlock = { () -> Void in }
        NSException(name: "Wrong init method", reason: "Use initForNewItem", userInfo: nil).raise()
        super.init(nibName: nil, bundle: nil)
        // Custom initialization
    }
    @objc(initForNewItem:)
    init(isNew:Bool) {
        self.dismissBlock = { () -> Void in }
        super.init(nibName:nil,bundle:nil)
        if isNew {
            let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                           target: self,
                                           action: "save:")
            self.navigationItem.rightBarButtonItem = doneItem
                let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                                                 target: self,
                                                 action: "cancel:")
            self.navigationItem.leftBarButtonItem = cancelItem
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        self.prepareViewsForOrientation(interfaceOrientation)
        let item = self.item
        self.nameField.text = item.itemName
        self.serialNumberField.text = item.serialNumber
        self.valueField.text = String(item.valueInDollars)
        self.dateLabel.text = BNRDetailViewController.dateFormatter.stringFromDate(item.dateCreated)
        let image = BNRImageStore.sharedStore.imageForKey(item.itemKey)
        self.imageView.image = image!
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        let item = self.item
        item.itemName = self.nameField.text
        item.serialNumber = self.serialNumberField.text
        item.valueInDollars = self.valueField.text.toInt()!
    }

    override func viewDidLayoutSubviews() {
        var subviews = self.view.subviews as UIView[]
        for subview:UIView in subviews {
            if subview.hasAmbiguousLayout() {
                NSLog("AMBIGUOUS LAYOUT : \(subview)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.prepareViewsForOrientation(toInterfaceOrientation)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        let image = info!.valueForKey(UIImagePickerControllerOriginalImage)! as UIImage
        BNRImageStore.sharedStore.setImage(image, forKey:self.item.itemKey)
        self.imageView.image = image
        if self.imagePickerPopover {
            self.imagePickerPopover!.dismissPopoverAnimated(true)
            self.imagePickerPopover = nil
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField:UITextField?) -> Bool {
        textField!.resignFirstResponder()
        return true
    }
    
    func prepareViewsForOrientation(orientation:UIInterfaceOrientation) {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return
        }
        if UIInterfaceOrientationIsLandscape(orientation) {
            self.imageView.hidden = true
            self.cameraButton.enabled = false
        } else {
            self.imageView.hidden = false
            self.cameraButton.enabled = true
        }
    }
    
    func popoverControllerDidDismissPopover(popoverController:UIPopoverController) {
        NSLog("popover was dismissed")
        self.imagePickerPopover = nil
    }
    
    func save(sender:AnyObject?) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: self.dismissBlock)
    }
    
    func cancel(sender:AnyObject?) {
        BNRItemStore.sharedStore.removeItem(self.item)
        self.presentingViewController.dismissViewControllerAnimated(true, completion: self.dismissBlock)
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
let GlobalDateFormatter = NSDateFormatter()
