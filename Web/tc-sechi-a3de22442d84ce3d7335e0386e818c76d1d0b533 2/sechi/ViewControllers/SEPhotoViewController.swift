//
//  SEPhotoViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import AVFoundation

/**
 *  View controller used for displaying single photo in gallery's UIPageViewcontroller
 */
class SEPhotoViewController: SEViewController, UIScrollViewDelegate {

    /**
     *  NSManagedObject with information about the photo to show.
     */
    var jobPhotoInfo: SEJobPhotoInfo!

    /**
     *  Scroll view that's used for displaying the photo
     */
    var scrollView: UIScrollView!

    /**
     *  Image view that will display a photo
     */
    var imageView: UIImageView!

    /**
     *  View with preview of the camera
     */
    @IBOutlet var previewView: UIView

    /**
     *  Current status of the scanner
     */
    @IBOutlet var statusLabel: UILabel

    /**
     *  BOOL indicating if scanner is currently trying to find, read and decode value.
     */
    var isReading: Bool = false

    /**
     *  Capture session used for video capture
     */
    var captureSession: AVCaptureSession!

    /**
     *  Video preview layer used for displaying current content seen by the camera
     */
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    /**
     *  Tap gesture recognizer used for informing delegate that the scanner wants to be dismissed.
     */
    var tapGestureRecognizer: UITapGestureRecognizer!

    /**
     *  Initialize ViewController with information about photo to display.
     *
     *  @param jobPhotoInfo
     *
     *  @return initialized view controller or nil if failure
     */
    init(jobPhotoInfo: SEJobPhotoInfo) {
        super.init(nibName: nil, bundle:nil)
        self.jobPhotoInfo = jobPhotoInfo
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        self.view.setNeedsUpdateConstraints()
    }

    /**
     *  Setup all view controller subviews.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 4.0
        self.scrollView.bounces = false
        self.scrollView.scrollEnabled = true
        self.view.addSubview(self.scrollView)
        self.scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        self.imageView = UIImageView()
        self.imageView.userInteractionEnabled = true
        self.imageView.multipleTouchEnabled = true
        self.imageView.contentMode = .ScaleAspectFit
        self.scrollView.addSubview(imageView)
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.scrollView.contentOffset = CGPointZero
        
        self.imageView.image = UIImage(contentsOfFile: self.jobPhotoInfo.filePath)
        
        self.view.setNeedsLayout()
    }

    /**
     *  Update constraints of views inside view controller.
     */
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.view.removeConstraints(self.view.constraints())
        
        var viewsDictionary = ["scrollView": self.scrollView, "imageView": self.imageView]

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: nil, metrics: nil, views:viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: nil, metrics: nil, views:viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView(width)]", options: nil, metrics: ["width": self.view.frame.size.width], views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView(height)]", options: nil, metrics: ["height": self.view.frame.size.height], views: viewsDictionary))
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView {
        return self.imageView
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView, atScale scale: Float) {
        
    }

}
