//
//  BOHTTPRequest.swift
//  BOHTTPRequest
//
//  Created by Oleg Bogatenko on 6/7/14.
//  Copyright (c) 2014 Oleg Bogatenko. All rights reserved.
//

import Foundation

class BOHTTPRequest : NSObject, NSURLConnectionDelegate {
    
    var url: NSURL
    
    var connection: NSURLConnection?
    var responseData: NSMutableData?
    var responseHeaders: NSDictionary?
    var request: NSMutableURLRequest?

    var completionBlock: (NSError?, NSDictionary?, NSData?) -> () = { (_, _, _) -> () in }
    
    // MARK: Initialize
    
    init(url: String) {
        
        self.url = NSURL(string: url)
    }
    
    func GET(completion: (NSError?, NSDictionary?, NSData?) -> ()) {
        
        self.completionBlock = completion
        
        self.request = NSMutableURLRequest(URL: self.url)
        self.request!.HTTPMethod = "GET"
        
        self.start()
    }
    
    func POST(postData: Dictionary<String, AnyObject>, completion: (NSError?, NSDictionary?, NSData?) -> ()) {
        
        self.completionBlock = completion
        
        self.request = NSMutableURLRequest(URL: self.url)
        self.request!.HTTPMethod = "POST"
        
        var postString = String()
        
        for (key, value : AnyObject) in postData {
            postString += "\(key)=\(value)&"
        }
        
        var data = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        self.request!.allHTTPHeaderFields = [ "Content-Length" : String(data.length) ]
        self.request!.HTTPBody = data
        
        self.start()
    }
    
    func start() {
        
        self.responseData = NSMutableData()
        
        self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
        self.connection!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.connection!.start()
        
        if (self.connection == nil) {
            
            var usrInfo = [NSLocalizedDescriptionKey : "connection error"]
            var error : NSError = NSError(domain: NSStringFromClass(BOHTTPRequest) , code: 0, userInfo: usrInfo)
            
            completionBlock(error, nil, nil)
        }
    }
    
    // MARK: NSURLConnection Delegate
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.responseData!.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        
        if (response.isKindOfClass(NSHTTPURLResponse)) {
            responseHeaders = response.allHeaderFields
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        completionBlock(nil, responseHeaders, responseData)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) { 
        completionBlock(error, nil, nil)
    }
}