//
//  PushBackTransition.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class PushBackTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let delta: CGFloat = 40.0
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        let duration = transitionDuration(transitionContext)
        
        let to_finalFrame = transitionContext.finalFrameForViewController(toVC)
        let to_initialFrame = CGRect(
            origin: CGPoint(x: to_finalFrame.origin.x - delta, y: to_finalFrame.origin.y),
            size: to_finalFrame.size)
        
        let overlayView = UIView(frame: toVC.view.bounds)
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0.5
        overlayView.opaque = false
        toVC.view.addSubview(overlayView)
        
        let from_finalFrame = CGRect(origin: CGPoint(x: containerView.bounds.width, y: fromVC.view.frame.origin.y), size: fromVC.view.frame.size)
        
        UIView.animateWithDuration(duration,
            animations: {
                fromVC.view.frame = from_finalFrame
                toVC.view.frame = to_finalFrame
                overlayView.alpha = 0.0
            },
            completion: { _ in
                overlayView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
    }
}