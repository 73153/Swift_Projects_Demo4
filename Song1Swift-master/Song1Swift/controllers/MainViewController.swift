//
//  MainViewController.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  var miniPlay: MiniPlayView?
  var currentViewController: UIViewController? {
    didSet {
      if let oldController = oldValue {
        oldController.willMoveToParentViewController(nil)
        oldController.view.removeFromSuperview()
        oldController.removeFromParentViewController()
      }
    }
    willSet {
      if let newController = newValue {
        addChildViewController(newController)
        self.view.addSubview(newController.view)
        newController.didMoveToParentViewController(self)
        self.miniPlay?.bringSubviewToFront(self.view)
      }
    }
  }
  var mineViewController: MineViewController
  var discoverViewController: DiscoverViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    mineViewController = MineViewController()
    discoverViewController = DiscoverViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func loadView() {
    let screenHeight = Ruler.windowHeight()
    let screenWidth = Ruler.windowWidth()
    self.view = UIView(frame: UIScreen.mainScreen().bounds)
    self.view.backgroundColor = UIColor.whiteColor()
    
    self.miniPlay = MiniPlayView(frame: CGRect(x: 0, y: screenHeight - 50, width: screenWidth, height: 50))
    self.view.addSubview(self.miniPlay!)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    self.initNaviationBar()
  }
  
  private func initNaviationBar() {
    self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    let tabBar = MainTabBar(frame: CGRect(x: 0, y: 0, width: 160, height: 44))
    self.navigationItem.titleView = tabBar
    
    tabBar.whenTabSelected { selectedItem in
      if selectedItem == 0 {
        self.currentViewController = self.mineViewController
      } else {
        self.currentViewController = self.discoverViewController
      }
    }
  }
}
