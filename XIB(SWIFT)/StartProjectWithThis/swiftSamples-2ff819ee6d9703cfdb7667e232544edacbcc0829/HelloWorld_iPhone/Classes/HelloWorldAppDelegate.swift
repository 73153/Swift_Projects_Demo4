//
//  HelloWorldAppDelegate.swift
//  HelloWorld
//
//  Created by Calman Steynberg on 2014-06-03.
//
//

import UIKit

@UIApplicationMain
class HelloWorldAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow!
    var myViewController: MyViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.myViewController = MyViewController(nibName: "HelloWorld", bundle: NSBundle.mainBundle())
        
        self.window.rootViewController = self.myViewController
        self.window.makeKeyAndVisible()
        
        return true
    }
    

}
