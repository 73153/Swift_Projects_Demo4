//
//  SERestClient.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-14.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import UIKit

var _restClientInstance: SERestClient? = nil

/**
 *  Singleton for performing REST requests
 */
class SERestClient: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    var apiErrorWasDisplayed: Bool = false
    var syncInterval: Double?
    var baseURL: NSURL?
    
    var RKFailureBlock: ((_: RKObjectRequestOperation?, _: NSError?) -> Void)!
    
    /**
     *  Returning singleton object
     *
     *  @return singleton object
     */
    class var instance: SERestClient {
        get {
            if _restClientInstance? {
                return _restClientInstance!
            }
            _restClientInstance = SERestClient()
            var dictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("values", ofType: "plist"))
            _restClientInstance!.baseURL = NSURL(string: dictionary.valueForKeyPath("APIUrl") as String)
            _restClientInstance!.syncInterval = dictionary.valueForKeyPath("SyncInterval") as? Double
            
            if !_restClientInstance!.baseURL? {
                UIAlertView(title: "API Base URL", message: "Base URL in values.plist file is incorrect, please check it's value.", delegate: nil, cancelButtonTitle: "Close").show()
            }
            
            if !_restClientInstance!.syncInterval? {
                UIAlertView(title: "Sync Interval", message: "Sync Interval in values.plist file is incorrect, please check it's value. Data sync loop will be disabled.", delegate: nil, cancelButtonTitle: "Close").show()
            }
            
            _restClientInstance!.restKitSetup()
            _restClientInstance!.syncTimer.fire()
            
            return _restClientInstance!
        }
    }
    
    /**
     *  Invalidates sync timer before destroing an object.
     */
    deinit {
        self.syncTimer.invalidate()
    }
    
    /**
     *  Setup RestKit Object Manager. BaseURL, cacheing, response and request descriptors, routes.
     */
    func restKitSetup() {
        var error: NSError? = nil
        var modelURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Model", ofType: "momd"))
        var managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL).mutableCopy() as NSManagedObjectModel
        var managedObjectStore = RKManagedObjectStore(managedObjectModel: managedObjectModel)
        managedObjectStore.createPersistentStoreCoordinator()
    
        var storePath = RKApplicationDataDirectory().stringByAppendingPathComponent("database.sqlite")
    
        NSFileManager.defaultManager().removeItemAtPath(storePath, error: &error)
        if error {
            NSLog("%@", error!)
            error = nil
        }
    
        var persistentStore = managedObjectStore.addSQLitePersistentStoreAtPath(storePath, fromSeedDatabaseAtPath: nil, withConfiguration: nil, options: nil, error: &error)
        assert(persistentStore, "Failed to add persistent store with error");
        managedObjectStore.createManagedObjectContexts()
        RKManagedObjectStore.setDefaultStore(managedObjectStore)
        self.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext
    
        var objectManager = RKObjectManager(baseURL: self.baseURL)
        objectManager.HTTPClient.setDefaultHeader("Content-Type", value: "application/x-www-form-urlencoded")
        objectManager.managedObjectStore = managedObjectStore
        RKObjectManager.setSharedManager(objectManager)
    
        self.setupResponseMapping()
    
        //    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace); // set all logs to trace,
        self.apiErrorWasDisplayed = false
    
        self.RKFailureBlock = {
            [unowned self] (operation, error) -> Void in
            if error? && !(error!.domain == NSURLErrorDomain && error!.code == -1009) {
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    self.showError()
                })
            }
        }
    }
    
    /**
     *  Show API error only once per application run, as an effect of using apiErrorWasDisplayed property.
     */
    func showError() {
        if !self.apiErrorWasDisplayed {
            self.apiErrorWasDisplayed = true
            UIAlertView(title: "Error", message: "API server is not responding, or base url is incorrect.", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    /**
     *  Setup RestKit responses mapping for all kind of objects used in application.
     */
    func setupResponseMapping() {
        var jobsMapping = SEJob.responseMappingForManagedObjectStore(RKObjectManager.sharedManager().managedObjectStore)
        var clientsMapping = SEClient.responseMappingForManagedObjectStore(RKObjectManager.sharedManager().managedObjectStore)
        var productsMapping = SEProduct.responseMappingForManagedObjectStore(RKObjectManager.sharedManager().managedObjectStore)
        var paymentsMapping = SEPayment.responseMappingForManagedObjectStore(RKObjectManager.sharedManager().managedObjectStore)
    
        var jobsListResponseDescriptor = RKResponseDescriptor(mapping: jobsMapping, method: .GET, pathPattern: "jobs", keyPath: "jobs", statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful))
        var clientsListResponseDescriptor = RKResponseDescriptor(mapping: clientsMapping, method: .GET, pathPattern: "clients", keyPath: "clients", statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful))
        var productsListResponseDescriptor = RKResponseDescriptor(mapping: productsMapping, method: .GET, pathPattern: "parts", keyPath: "parts", statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful))
        var paymentsListResponseDescriptor = RKResponseDescriptor(mapping: paymentsMapping, method: .GET, pathPattern: "payments", keyPath: "payments", statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful))
        RKObjectManager.sharedManager().addResponseDescriptor(jobsListResponseDescriptor)
        RKObjectManager.sharedManager().addResponseDescriptor(clientsListResponseDescriptor)
        RKObjectManager.sharedManager().addResponseDescriptor(productsListResponseDescriptor)
        RKObjectManager.sharedManager().addResponseDescriptor(paymentsListResponseDescriptor)
    }
    
    func refreshJobsList() {
        RKObjectManager.sharedManager().getObjectsAtPath("jobs", parameters: nil, success: nil, failure: self.RKFailureBlock)
    }
    
    func refreshClientsList() {
        RKObjectManager.sharedManager().getObjectsAtPath("clients", parameters: nil, success: nil, failure: self.RKFailureBlock)
    }
    
    func refreshPaymentsList() {
        RKObjectManager.sharedManager().getObjectsAtPath("payments", parameters: nil, success: nil, failure: self.RKFailureBlock)
    }
    
    func refreshPartsList() {
        RKObjectManager.sharedManager().getObjectsAtPath("parts", parameters: nil, success: nil, failure: self.RKFailureBlock)
    }
    
    /**
     *  This time is used to run database sync every [time interval from plist] seconds.
     *
     *  @return NSTimer object used for firing update;
     */
    var syncTimer: NSTimer {
        get {
            if !_syncTimer {
                _syncTimer = NSTimer(timeInterval: self.syncInterval!, target: self, selector: "performDataSync:", userInfo: nil,  repeats: true)
    
                NSRunLoop.mainRunLoop().addTimer(_syncTimer, forMode: NSRunLoopCommonModes)
            }
            return _syncTimer!
        }
    }
    var _syncTimer: NSTimer? = nil
    
    /**
     *  Action called by syncTimer. Starts running all sync methods in a MainThred.
     *
     *  @param timer NSTimer class object that called this method (sender).
     */
    func performDataSync(timer: NSTimer) {
        NSLog("Data sync will occur now...")
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            self.performDataSync()
        })
    }
    
    /**
     *  Runs all methods for syncing data,
     */
    func performDataSync() {
        SERestClient.instance.refreshJobsList()
        SERestClient.instance.refreshClientsList()
        SERestClient.instance.refreshPartsList()
        SERestClient.instance.refreshPaymentsList()
    }
}
