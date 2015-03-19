//
//  TSDCenteredTabBarController.swift
//  SwiftCenteredTabBar
//
//  Created by Tobias Schmid on 03.06.14.
//  Copyright (c) 2014 toashd. All rights reserved.
//

import UIKit

class TSDCenteredTabBarController: UITabBarController {

    var centerButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        var buttonImage = UIImage(named: "tabBarCameraCenter")
        var buttonImageActive = UIImage(named: "tabBarCameraCenterActive")

        self.addCenterButtonWithImage(
            buttonImage,
            highlightImage: buttonImageActive,
            target: self,
            action:Selector("buttonPressed:")
        )
    }

    override func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!) {
        if item == self.tabBar.items[self.tabBar.items.count / 2] as NSObject {
            centerButton.selected = true
        } else {
            centerButton.selected = false
        }
    }

    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage: UIImage, target: AnyObject, action: Selector) {

        var button : UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)

        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)

        button.setBackgroundImage(highlightImage, forState: UIControlState.Selected)
        button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)

        var heightDifference = buttonImage.size.height - self.tabBar.frame.size.height
        if heightDifference < 0 {
            button.center = self.tabBar.center
        } else {
            var center = self.tabBar.center
            center.y = center.y - heightDifference / 2.0
            button.center = center
        }

        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(button)
        self.centerButton = button
    }

    func buttonPressed(sender: AnyObject) {
        self.selectedIndex = self.tabBar.items.count / 2
        centerButton.selected = true
    }
    
}
