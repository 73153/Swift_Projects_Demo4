//
//  SiteTileView.swift
//  Sights
//
//  Created by llv22 on 8/3/14.
//  Copyright (c) 2014 llv22. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable //Objective-C IB_DESIGNABLE
class SiteTileView: UIView {
    var backgroundRingLayer: CAShapeLayer!
    var ringLayer: CAShapeLayer!
    
    @IBInspectable var rating: Double = 0.6 {
    didSet { updateLayerProperties()}
    }
    var lineWidth: Double = 10.0 {
    didSet { updateLayerProperties()}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //see add ringlayer
        if !backgroundRingLayer {
            backgroundRingLayer = CAShapeLayer()
            layer.addSublayer(backgroundRingLayer)
            
//            let rect = bounds
            let rect = CGRectInset(bounds, CGFloat(lineWidth / 2.0), CGFloat(lineWidth / 2.0))
            let path  = UIBezierPath(ovalInRect: rect)
            
            backgroundRingLayer.path = path.CGPath
            backgroundRingLayer.fillColor = nil
            backgroundRingLayer.lineWidth = CGFloat(lineWidth)
            backgroundRingLayer.strokeColor = UIColor(white: 0.5, alpha: 0.3).CGColor
        }
        backgroundRingLayer.frame = layer.bounds
        
        if !ringLayer {
            ringLayer = CAShapeLayer()
            
            let innerRect = CGRectInset(bounds, CGFloat(lineWidth / 2.0), CGFloat(lineWidth / 2.0))
            let innerPath = UIBezierPath(ovalInRect: innerRect)
            
            ringLayer.path = innerPath.CGPath
            ringLayer.fillColor = nil
            ringLayer.lineWidth = CGFloat(lineWidth)
            ringLayer.strokeColor = UIColor.blueColor().CGColor
            ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
            ringLayer.transform = CATransform3DRotate(ringLayer.transform, CGFloat(-M_PI/2), 0, 0, 1)
            layer.addSublayer(ringLayer)
        }
        ringLayer.frame = layer.bounds
        
        updateLayerProperties()
    }
    
    func updateLayerProperties(){
        if ringLayer {
            ringLayer.strokeEnd = CGFloat(rating)
            
            var storkeColor = UIColor.lightGrayColor()
            switch rating {
            case let r where r >= 0.75:
                storkeColor = UIColor(hue: 112.0/360.0, saturation: 0.3, brightness: 0.85, alpha: 1.0);
            case let r where r >= 0.5:
                storkeColor = UIColor(hue: 208.0/360.0, saturation: 0.51, brightness: 0.75, alpha: 1.0)
            case let r where r >= 0.25:
                storkeColor = UIColor(hue: 40.0/360.0, saturation: 0.39, brightness: 0.85, alpha: 1.0)
            default:
                storkeColor = UIColor(hue: 359.0/360.0, saturation: 0.48, brightness: 0.63, alpha: 1.0);
            }
            ringLayer.strokeColor = storkeColor.CGColor
        }
    }
    
}
