//
//  RSDialArtwrokView.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/03.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol RSDialArtworkViewDelegate : NSObjectProtocol {
    @optional func willStartChangingElapsedTimeInDialArtworkView(dialArtworkView: RSDialArtwrokView!)
    @optional func didEndChangingElapsedTimeInDialArtworkView(dialArtworkView: RSDialArtwrokView!)
    @optional func dialArtworkView(dialArtworkView: RSDialArtwrokView!, shouldChangeElapsedTime elapsedTime: CGFloat) -> Bool
    @optional func dialArtworkView(dialArtworkView: RSDialArtwrokView!, didChangeElapsedTime elapsedTime: CGFloat)
}

class RSDialArtwrokView: UIView, UITableViewDelegate {

    struct ViewInfo {
        static let arcLineWidth: CGFloat = 4.0
        static let thumbRadius: CGFloat = 14.0
    }
    
    // MARK: Public Properties
    var artworkImage: UIImage? {
        didSet {
            self.artworkImageView.image = artworkImage
        }
    }
    var duration: CGFloat = 0.0 {
        didSet {
            self.updateProgress()
        }
    }
    var elapsedTime: CGFloat = 0.0 {
        didSet {
            if elapsedTime < 0.0 {
                elapsedTime = 0.0
            }
            self.updateProgress()
        }
    }
    weak var delegate: RSDialArtworkViewDelegate?
    
    // MARK: Private
    var artworkImageView: UIImageView!
    var elapsedArc: CAShapeLayer!
    var remainArc: CAShapeLayer!
    var thumbImageView: UIImageView!
    
    var progress: CGFloat = 0.0    
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.setup()
    }

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        // Initialization code
        self.setup()
    }
    
    func setup() {
        self.setupArtworkView()
        self.setupProgressTracker()
    }
    
    func setupArtworkView() {
        self.artworkImageView = UIImageView(frame: self.bounds)
        self.artworkImageView.contentMode = .ScaleAspectFill
        
        let center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        let radius = center.x - (ViewInfo.thumbRadius-ViewInfo.arcLineWidth/2.0)
        let path  = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        self.artworkImageView.layer.mask = maskLayer
        self.clipsToBounds = true
        
        self.addSubview(artworkImageView)
    }
    
    func setupProgressTracker() {
        // Setup ElapsedArc
        self.elapsedArc = CAShapeLayer()
        self.elapsedArc.lineWidth = ViewInfo.arcLineWidth
        self.elapsedArc.strokeColor = UIColor.rgbColorWithRed(108, green: 155, blue: 210, alpha: 1.0).CGColor
        self.elapsedArc.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(self.elapsedArc)
        
        // Setup RemainArc
        self.remainArc = CAShapeLayer()
        self.remainArc.lineWidth = ViewInfo.arcLineWidth
        self.remainArc.strokeColor = UIColor.grayColor().CGColor
        self.remainArc.fillColor =  UIColor.clearColor().CGColor
        self.layer.addSublayer(self.remainArc)
        
        // Setup Thumb
        self.thumbImageView = UIImageView(image: UIImage(named: "player_icon_slider_thumb"))
        let panGesture = UIPanGestureRecognizer(target: self, action: "handleThumbPangesture:")
        self.thumbImageView.addGestureRecognizer(panGesture)
        self.thumbImageView.userInteractionEnabled = true
        self.addSubview(self.thumbImageView)
    }

    func arcPathWithStartPosition(startPosition: CGFloat, endPosition: CGFloat) -> CGPath {
        let startAngle = (2.0 * CGFloat(M_PI) * startPosition) - CGFloat(M_PI_2)
        let endAngle = (2.0 * CGFloat(M_PI) * endPosition) - CGFloat(M_PI_2)
        let center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        let radius = center.x - (ViewInfo.thumbRadius-ViewInfo.arcLineWidth/2.0)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle:endAngle, clockwise:true)
        return path.CGPath
    }
    
    func thumbFrameWithProgress(progress: CGFloat) -> CGRect {
        let centerX = self.frame.size.width / 2.0
        let radius = centerX - (ViewInfo.thumbRadius-ViewInfo.arcLineWidth/2.0)
        let angle = (CDouble)(2 * CGFloat(M_PI) * progress) - M_PI_2
        let xPos = centerX + radius * CGFloat(cos(angle))
        let yPos = centerX + radius * CGFloat(sin(angle))
        return CGRect(x: xPos-ViewInfo.thumbRadius, y: yPos-ViewInfo.thumbRadius,
            width: ViewInfo.thumbRadius*2, height: ViewInfo.thumbRadius*2)
    }
    
    // MARK: Gesture
    func handleThumbPangesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .Began:
                self.delegate?.willStartChangingElapsedTimeInDialArtworkView?(self)

            case .Changed:
                let point = gesture.locationInView(self)
                let center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
                let centerDx = point.x-center.x
                let centerDy = point.y-center.y
                let rad = CDouble(centerDy/centerDx)
                var angle = atan(rad)
                if centerDx < 0.0 {
                    angle += M_PI
                }
                let progress = (angle+M_PI_2) / (2*M_PI)
                self.moveToProgress(CGFloat(progress))
            
            case .Ended, .Cancelled:
                self.delegate?.didEndChangingElapsedTimeInDialArtworkView?(self)
            
            default:
                break
        }
    }
    
    func moveToProgress(progress: CGFloat) {
        var delta = self.progress - progress
        if delta < 0 {
            delta = -delta
        }
        if delta < 0.05 {
            // ISSUE: respondsToSelector always return ture
            if self.delegate?.respondsToSelector("dialArtworkView:shouldChangeElapsedTime:") {
                let elapsedTime = self.duration * progress
                if !self.delegate?.dialArtworkView?(self, shouldChangeElapsedTime: CGFloat(elapsedTime)) {
                    return
                }
            }
            
            self.changeProgress(progress)
            if self.delegate?.respondsToSelector("dialArtworkView:didChangeElapsedTime:") {
                self.delegate?.dialArtworkView?(self, didChangeElapsedTime: self.elapsedTime)
            }
        }
    }
    
    func changeProgress(progress: CGFloat) {
        self.elapsedTime = self.duration * progress
        self.updateProgress()
    }
    
    func updateProgress() {
        let progress = (self.duration>0.0) ? self.elapsedTime/self.duration : 0.0
        self.progress = progress
        self.elapsedArc.path = self.arcPathWithStartPosition(0.0, endPosition: progress)
        self.remainArc.path = self.arcPathWithStartPosition(progress, endPosition: 1.0)
        self.thumbImageView.frame = self.thumbFrameWithProgress(progress)
    }
}
