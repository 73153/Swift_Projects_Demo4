//
//  RootViewController.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/13/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UINavigationControllerDelegate {
    @lazy var interactiveTransitionController = PanInteractiveTransition()
    @lazy var pushBackTransition = PushBackTransition()
    
    func navigationController(navigationController: UINavigationController!, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning! {
        return interactiveTransitionController.interactionInProgress ? interactiveTransitionController : nil
    }
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        if operation == .Push {
            interactiveTransitionController.attachToViewController(toVC)
        }
        return operation == .Pop ? pushBackTransition : nil
    }
}