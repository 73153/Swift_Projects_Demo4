//
//  AppDelegate.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = UINavigationController(rootViewController: MainViewController(nibName: nil, bundle: nil))
    self.window?.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }


}

