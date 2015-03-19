//
//  APLGestureRecognizerViewController.swift
//  SimpleGestureRecognizers
//
//  Created by Calman Steynberg on 2014-06-05.
//
//

import UIKit

class APLGestureRecognizerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer
    @IBOutlet var swipeLeftRecognizer: UISwipeGestureRecognizer
    
    @IBOutlet var imageView: UIImageView
    @IBOutlet var segmentedControl: UISegmentedControl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        } else {
            self.view.removeGestureRecognizer(self.swipeLeftRecognizer)
        }
        
        self.segmentedControl.exclusiveTouch = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func supportedInterfaceOrientations() -> Int {
    //        return UIInterfaceOrientationMask.All.toRaw()
    //    }
    
    @IBAction func takeLeftSwipeRecognitionEnabledFrom(aSegmentedControl: UISegmentedControl) {
        
        /*
        Add or remove the left swipe recogniser to or from the view depending on the selection in the segmented control.
        */
        if aSegmentedControl.selectedSegmentIndex == 0 {
            self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        } else {
            self.view.removeGestureRecognizer(self.swipeLeftRecognizer)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch) -> Bool {
        
        // Disallow recognition of tap gestures in the segmented control.
        if touch.view === self.segmentedControl && gestureRecognizer === self.tapRecognizer {
            return false
        }
        return true
        
    }
    
    
    // MARK - Responding to gestures
    
    /*
    In response to a tap gesture, show the image view appropriately then make it fade out in place.
    */
    @IBAction func showGestureForTapRecognizer(recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.locationInView(self.view)
        self.drawImageForGestureRecognizer(recognizer, atPoint:location)
        
        UIView.animateWithDuration(0.5) {
            self.imageView.alpha = 0.0
        }
    }
    
    
    /*
    In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
    */
    @IBAction func showGestureForSwipeRecognizer(recognizer: UISwipeGestureRecognizer) {
        
        var location = recognizer.locationInView(self.view)
        self.drawImageForGestureRecognizer(recognizer, atPoint:location)
        
        if recognizer.direction == .Left {
            location.x -= 220.0
        }
        else {
            location.x += 220.0
        }
        
        UIView.animateWithDuration(0.5) {
            self.imageView.alpha = 0.0
            self.imageView.center = location
        }
    }
    
    
    /*
    In response to a rotation gesture, show the image view at the rotation given by the recognizer. At the end of the gesture, make the image fade out in place while rotating back to horizontal.
    */
    @IBAction func showGestureForRotationRecognizer(recognizer: UIRotationGestureRecognizer) {
        
        var location = recognizer.locationInView(self.view)
        
        let transform = CGAffineTransformMakeRotation(recognizer.rotation)
        self.imageView.transform = transform
        self.drawImageForGestureRecognizer(recognizer, atPoint:location)
        
        /*
        If the gesture has ended or is cancelled, begin the animation back to horizontal and fade out.
        */
        if recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled {
            UIView.animateWithDuration(0.5) {
                self.imageView.alpha = 0.0
                self.imageView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    
    // MARK - Drawing the image view
    
    /*
    Set the appropriate image for the image view for the given gesture recognizer, move the image view to the given point, then dispay the image view by setting its alpha to 1.0.
    */
    func drawImageForGestureRecognizer(recognizer: UIGestureRecognizer, atPoint centerPoint:CGPoint) {
        
        var imageName: String?
        
        if recognizer.isMemberOfClass(UITapGestureRecognizer) {
            imageName = "tap.png"
        } else if recognizer.isMemberOfClass(UIRotationGestureRecognizer) {
            imageName = "rotation.png"
        } else if recognizer.isMemberOfClass(UISwipeGestureRecognizer) {
            imageName = "swipe.png"
        }
        
        self.imageView.image = UIImage(named:imageName?)
        self.imageView.center = centerPoint
        self.imageView.alpha = 1.0
    }
    
}
