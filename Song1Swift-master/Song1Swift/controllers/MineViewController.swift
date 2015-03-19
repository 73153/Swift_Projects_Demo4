//
//  MineViewController.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/22.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class MineViewController : UIViewController {
  override func viewDidLoad() {
  }
  
  override func viewWillAppear(animated: Bool) {
    var animation = CATransition()
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionFade
    self.navigationController?.navigationBar.layer.addAnimation(animation, forKey: nil)
    self.navigationController?.navigationBar
      .setBackgroundImage(UIImage(named: "mine_menubar"), forBarMetrics: UIBarMetrics.Default)
  }
}
