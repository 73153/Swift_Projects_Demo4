//
//  AppDelegate.swift
//  MathKit
//
//  Created by Robert Dimitrov on 6/15/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        
        var rectangle = Rectangle(origin: Point(x: 4, y: 5), width: 80, height: 40);
        println("area is \(rectangle.area())");
        
        var circle = Circle(center: Point(x: 20, y: 20), radius: 30)
        
        var point1 = Point(x: 10, y: 10);
        var point2 = Point(x: 100, y: 10);
        
        println("circle contains point: \(circle.containsPoint(point1))")
        println("rectangle contains point: \(rectangle.containsPoint(point1))")
        
        println("circle contains point: \(circle.containsPoint(point2))")
        println("rectangle contains point: \(rectangle.containsPoint(point2))")
        
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.endIndex-1] as UINavigationController
        splitViewController.delegate = navigationController.topViewController as DetailViewController
        return true
    }
}
