//
//  PanInteractiveTransition.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class PanInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    var shouldCompleteTransition = false
    var navigationController: UINavigationController!
    
    init() {
        super.init()
        completionSpeed = 0.5
    }
    
    func attachToViewController(viewController: UIViewController) {
        navigationController = viewController.navigationController
        let pan = UIPanGestureRecognizer(target: self, action: "panned:")
        viewController.view.addGestureRecognizer(pan)
    }
    
    func panned(pan: UIPanGestureRecognizer) {
        let translationInView = pan.translationInView(pan.view.superview)
        
        switch pan.state {
        case .Began:
            interactionInProgress = true
            navigationController.popViewControllerAnimated(true)
        case .Changed:
            var percent = translationInView.x / pan.view.superview.bounds.width
            percent = fminf(fmaxf(percent, 0.0), 1.0)
            println("percent: \(percent)")
            shouldCompleteTransition = percent > 0.54
            updateInteractiveTransition(percent)
        case .Ended, .Cancelled:
            interactionInProgress = false
            
            if (!shouldCompleteTransition || pan.state == .Cancelled) && pan.velocityInView(pan.view.superview).x < 800.0 {
                cancelInteractiveTransition()
                return
            }
            finishInteractiveTransition()
        default:
            break
        }
    }
}
