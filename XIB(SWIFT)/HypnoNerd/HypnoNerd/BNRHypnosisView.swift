//
//  BNRHypnosisView.swift
//  Hypnosister
//
//  Created by Han Kang on 6/9/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRHypnosisView: UIView {
    var _circleColor = UIColor.clearColor()
    var circleColor:UIColor {
        get {
            return _circleColor
        }
        set(color) {
            _circleColor = color;
            self.setNeedsDisplay()
        }
    }
    init(frame: CGRect) {
        super.init(frame: frame)
        self.circleColor = UIColor.lightGrayColor()
        self.backgroundColor = UIColor.clearColor()
    }
    override func drawRect(rect: CGRect)
    {
        let bounds = self.bounds
        var center = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0
        var maxRadius = hypotf(bounds.size.width, bounds.size.height) / 2.0
//        var radius = (min(bounds.size.width, bounds.size.height) / 2.0) - 5
        var path = UIBezierPath()
        for (var currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
            var pointToMove = CGPointMake(center.x+currentRadius, center.y)
            path.moveToPoint(pointToMove)
            path.addArcWithCenter(center,radius:currentRadius,startAngle:0.0,endAngle:2.0, clockwise:true)
        }
 
        path.lineWidth = 10
        self.circleColor.setStroke()
        path.stroke()
        
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("asdf")
        if (self.circleColor == UIColor.lightGrayColor()) {
            NSLog("here i am")
            self.circleColor = UIColor.blueColor()
        }
        else {
            NSLog("here i amf fd")
            self.circleColor = UIColor.lightGrayColor()
        }
        //        UIColor.colorWithAlphaComponent(UIColor)
//        self.circleColor = UIColor.colorWithRed(red:red,green:green,blue:blue,alpha:1.0)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
