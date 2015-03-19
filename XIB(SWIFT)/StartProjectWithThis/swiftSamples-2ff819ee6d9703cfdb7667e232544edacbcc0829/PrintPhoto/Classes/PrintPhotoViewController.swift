//
//  PrintPhotoViewController.swift
//  PrintPhoto
//
//  Created by Calman Steynberg on 2014-06-03.
//
//

import UIKit
import MobileCoreServices
import AssetsLibrary

let DIRECT_SUBMISSION = true

// Leave this line intact to use an ALAsset object to obtain a screen-size image and use
// that instead of the original image. Doing this allows viewing of images of a very
// large size that would otherwise be prohibitively large on most
// iOS devices.
let USE_SCREEN_IMAGE = true

let kToolbarHeight: Float = 48

class PrintPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate {

    
    @IBOutlet var imageView : UIImageView
    @IBOutlet var toolbar: UIToolbar
    var printButton: UIBarButtonItem!
    var pickerButton: UIBarButtonItem!
    var imageURL: NSURL!
    var popover: UIPopoverController!

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var toolbarFrame: CGRect
        var path: NSString
        
        var bounds = UIScreen.mainScreen().applicationFrame
        
        // Set the properties on our image view.
        imageView.backgroundColor = UIColor.blackColor()
        
        // Obtain the starting image presented prior to the user choosing one.
        path = NSBundle.mainBundle().pathForResource("FirstImage", ofType:"jpg")
        // Load the image at that path.
        imageView.image = UIImage(contentsOfFile:path)
        
        // Use that image as the image to print.
        if(imageView.image) {
            self.imageURL = NSURL(fileURLWithPath:path, isDirectory:false)
        }
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            // For the iPad we'll put the toolbar at the top.
            toolbarFrame = CGRectMake(0, 0, bounds.size.width, kToolbarHeight)
            
            var imageView = PASImageView(frame: toolbarFrame)
            
            imageView.backgroundProgressColor(UIColor.whiteColor())
            
            imageView.progressColor(UIColor.redColor())
                
                self.view.addSubview(imageView)
                // Later
            imageView.imageURL(self.imageURL)
            
        } else {
            toolbarFrame = CGRectMake(0, bounds.size.height - kToolbarHeight, bounds.size.width, kToolbarHeight)
            var imageView = PASImageView(frame:  CGRectMake(100,200,100,100))
            
            imageView.backgroundProgressColor(UIColor.whiteColor())
            
            imageView.progressColor(UIColor.redColor())
            
            self.view.addSubview(imageView)
            // Later
            imageView.imageURL(self.imageURL)
        }
     
        
  
        
        // Allow the image view to size as the orientation changes.
        self.setupToolbarItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupToolbarItems() {
        // Use the system camera icon as the toolbar icon for choosing to select a photo from the photo library.
        self.pickerButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Camera, target:self, action:"showImagePicker:")
        
        // Only add an icon for selecting printing if printing is available on this device.
        if UIPrintInteractionController.isPrintingAvailable() {
            var spaceItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
            
            self.printButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Action, target:self, action:"printImage:")
            
            self.toolbar.items = [self.pickerButton, spaceItem, self.printButton];
        } else {
            self.toolbar.items = [self.pickerButton];
        }
    }
    
    // Invoked when the user chooses the action icon for printing.
    func printImage(sender: AnyObject?) {
        // Obtain the shared UIPrintInteractionController
        let controller:UIPrintInteractionController = UIPrintInteractionController.sharedPrintController()
        
        // Obtain a printInfo so that we can set our printing defaults.
        var dictionary = NSDictionary()
        var printInfo:UIPrintInfo = UIPrintInfo(dictionary:dictionary)
        var image = self.imageView.image
        
        // This application prints photos. UIKit will pick a paper size and print
        // quality appropriate for this content type.
        printInfo.outputType = .Photo
        // The path to the image may or may not be a good name for our print job
        // but that's all we've got.
        printInfo.jobName = self.imageURL.path.lastPathComponent
        
        // If we are performing drawing of our image for printing we will print
        // landscape photos in a landscape orientation.
        if(!controller.printingItem && image.size.width > image.size.height) {
            printInfo.orientation = .Landscape;
        }
        
        // Use this printInfo for this print job.
        controller.printInfo = printInfo
        
        //  Since the code below relies on printingItem being zero if it hasn't
        //  already been set, this code sets it to nil.
        controller.printingItem = nil
        
        
        #if DIRECT_SUBMISSION
            // Use the URL of the image asset.
            if self.imageURL && UIPrintInteractionController.canPrintURL(self.imageURL) {
                controller.printingItem = self.imageURL
            }
        #endif
        
        // If we aren't doing direct submission of the image or for some reason we don't
        // have an ALAsset or URL for our image, we'll draw it instead.
        if !controller.printingItem {
            // Create an instance of our PrintPhotoPageRenderer class for use as the
            // printPageRenderer for the print job.
            var pageRenderer = PrintPhotoPageRenderer()
            // The PrintPhotoPageRenderer subclass needs the image to draw. If we were taking
            // this path we use the original image and not the fullScreenImage we obtained from
            // the ALAssetRepresentation.
            pageRenderer.imageToPrint = self.imageView.image
            controller.printPageRenderer = pageRenderer
            
        }

        // The method we use presenting the printing UI depends on the type of
        // UI idiom that is currently executing. Once we invoke one of these methods
        // to present the printing UI, our application's direct involvement in printing
        // is complete. Our delegate methods (if any) and page renderer methods (if any)
        // are invoked by UIKit.
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            controller.presentFromBarButtonItem(self.printButton, animated: true) { controller, completed, error in
                if completed && error? {
                    NSLog("FAILED! due to error in domain %@ with error code %u", error.domain, error.code)
                }
            }
        } else {
            controller.presentAnimated(true) { controller, completed, error in
                if completed && error? {
                    NSLog("FAILED! due to error in domain %@ with error code %u", error.domain, error.code)
                }
            }
        }
        
    }

    // Show the image picker when the user wants to choose an image.
    func showImagePicker(sender: AnyObject?) {
        // Dismiss any printing popover that might already be showing.
        if (UIPrintInteractionController.isPrintingAvailable() && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            UIPrintInteractionController.sharedPrintController().dismissAnimated(true)
        }
        // If a popover is already showing, dismiss it.
        if (self.popover){
            self.popover.dismissPopoverAnimated(true)
            self.popover = nil;
            return
        }
        
        // UIImagePickerController let's the user choose an image.
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // On the iPad we need to present the image picker in a popover.
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            // If a popover is already showing, dismiss it before presenting a new one.
            // We own this instance of the popover controller but will release it in popoverControllerDidDismissPopover.
            var popoverController = UIPopoverController(contentViewController:imagePicker)
            popoverController.delegate = self
            self.popover = popoverController
            popoverController.presentPopoverFromBarButtonItem(self.pickerButton, permittedArrowDirections:UIPopoverArrowDirection.Any, animated:true)
        } else {
            self.presentViewController(imagePicker, animated:true, completion:{})
        }
    }
    
    func imagePickerController( picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        if(info){
            // Don't pay any attention if somehow someone picked something besides an image.

            if (info[UIImagePickerControllerMediaType].isEqualToString(kUTTypeImage)) {
                // Hand on to the asset URL for the picked photo..
                self.imageURL = info[UIImagePickerControllerReferenceURL] as NSURL
                
#if USE_SCREEN_IMAGE
                    // To get an asset library reference we need an instance of the asset library.
                    var assetsLibrary = ALAssetsLibrary()
                    var osVersion = UIDevice.currentDevice().systemVersion
                    var versionWithoutRotation = "5.0"
                    var noRotationNeeded = versionWithoutRotation.compare(osVersion, options:.NumericSearch) != .OrderedDescending
                    // The assetForURL: method of the assets library needs a block for success and
                    // one for failure. The resultsBlock is used for the success case.
                    var resultsBlock: ALAssetsLibraryAssetForURLResultBlock  = {
                        var representation = asset.defaultRepresentation()
                        var image = representation.fullScreenImage()
                        if(noRotationNeeded){
                            // Create a UIImage from the full screen image. The full screen image
                            // is already scaled and oriented properly.
                            imageView.image = UIImage(withCGImage:image)
                        }else{
                            // prior to iOS 5.0, the screen image needed to be rotated so
                            // make sure that the UIImage we create from the CG image has the appropriate
                            // orientation, based on the EXIF data from the image.
                            var orientation = representation.orientation
                            imageView.image = UIImage(withCGImage:image, scale:1.0, orientation:orientation as UIImageOrientation)
                        }
                    }
                    var failureBlock: ALAssetsLibraryAccessFailureBlock = {
                        /*  A failure here typically indicates that the user has not allowed this app access
                        to location data. In that case the error code is ALAssetsLibraryAccessUserDeniedError.
                        In principle you could alert the user to that effect, i.e. they have to allow this app
                        access to location services in Settings > General > Location Services and turn on access
                        for this application.
                        */
                        NSLog("FAILED! due to error in domain %@ with error code %d", error.domain, error.code)
                        // This sample will abort since a shipping product MUST do something besides logging a
                        // message. A real app needs to inform the user appropriately.
                        abort()
                    };
                    
                    // Get the asset for the asset URL to create a screen image.
                    assetsLibrary.assetForURL(self.imageURL, resultBlock:resultsBlock, failureBlock:failureBlock)
                    // Release the assets library now that we are done with it.
#else
                    // If we aren't using a screen sized image we'll use the original one.
                    imageView.image = info[UIImagePickerControllerOriginalImage] as UIImage
#endif
                
                // If we were presented with a popover, dismiss it.
                if(self.popover){
                    self.popover.dismissPopoverAnimated(true)
                    self.popover = nil;
                }else {
                    // Dismiss the modal view controller if we weren't presented from a popover.
                    self.dismissViewControllerAnimated(true) {
                        }
                }
            }
        }
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController?) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController?) {
        self.popover = nil
    }
    
}
    
}