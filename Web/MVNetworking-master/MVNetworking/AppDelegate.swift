//
//  AppDelegate.swift
//  MVNetworking
//
//  Created by Michael on 6/3/14.
//  Copyright (c) 2014 __MICHAEL_VOZNESENSKY__. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        var swiftApplicationManager = NetworkingManagerSingleton.sharedInstance
        let URLForConnection = "http://ec2-54-237-141-89.compute-1.amazonaws.com:8080/trendingservices/api/user/login"
        let httpBodyDict = [
            "userName" : "test",
            "password" : "test"
        ]
        let httpHeaderDict = [
            "Content-Type":"application/json",
            "Accept":"application/json"
        ]

        
        
        var appDelegateError:NSError?
        let imageData:NSData = UIImagePNGRepresentation(UIImage(named: "sloth"))
//        let imageData:NSData = NSData.alloc()
        UIImage(named: "sloth")
        let urlForMultiPartFormConnection = "http://ec2-54-237-141-89.compute-1.amazonaws.com:8080/trendingservices/api/poll/postImage"
        
        
        swiftApplicationManager.POSTDataWithJSON (URLForConnection, httpHeaderDictionary: httpHeaderDict, httpBodyDictionary: httpBodyDict, onCompletion:{ (response:Dictionary<NSObject,AnyObject>) -> Void in
            println(" \(response) ")
            println("test")
            
            
            let multiPartFormDict = [
                "imageOne" : imageData
            ]
            
            swiftApplicationManager.POSTDataWithMultiPartForm(urlForMultiPartFormConnection, httpBodyDictionary: multiPartFormDict, onCompletion:{ (response: Dictionary<NSObject, AnyObject>) -> Void in
                
                println(" \(response) ")
                println("test2")
                })
        
        })
        
        
        
        
        return true
    }
    
    
    func comeBackWithResponse(responseString: AnyObject) {
        
        println("data string is : \(responseString)")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
}

