//
//  MVNetworkingManager.swift
//  MVNetworking
//
//  Created by Michael on 6/3/14.
//  Copyright (c) 2014 __MICHAEL_VOZNESENSKY__. All rights reserved.
//

import Foundation

protocol MVNetworkingManagerResponsesDelegate {
    func comeBackWithResponse(responseString:AnyObject)
}


class NetworkingManagerSingleton {
    var delegate : MVNetworkingManagerResponsesDelegate?
    
    class var sharedInstance:NetworkingManagerSingleton{
        get {
            struct Static {
                static var instance : NetworkingManagerSingleton? = nil
                static var token : dispatch_once_t = 0;
                
            }
            
            dispatch_once(&Static.token) {
                Static.instance = NetworkingManagerSingleton()
            }
            return Static.instance!;
        }
    }

    
    //TESTED
    func POSTDataWithJSON (urlStringForConnection:String, httpHeaderDictionary:Dictionary <String, String>, httpBodyDictionary:Dictionary <String, String>, onCompletion: (response:Dictionary<NSObject,AnyObject>) -> Void){
        
        let sampleUrl : NSURL = .URLWithString(urlStringForConnection)
        let request = NSMutableURLRequest(URL: sampleUrl)
        let queue = NSOperationQueue()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        var localClassErrorNetworking: NSError?
        
        let keyArray:Array = Array(httpHeaderDictionary.keys)
        let valueArray:Array = Array(httpHeaderDictionary.values)
        
        for (var i = 0; i < keyArray.count; i++){
            let key:String = keyArray[i]
            let value:String = valueArray[i]
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(httpBodyDictionary, options: NSJSONWritingOptions(),error: &localClassErrorNetworking)
        request.HTTPMethod = "POST"
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest( request, completionHandler:{ (data : NSData!, response: NSURLResponse!, error : NSError!) -> Void in
            
            let byteString : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &localClassErrorNetworking) as NSDictionary
            
            let dictionaryFromNSDictionaryJSON:Dictionary = byteString
            onCompletion(response:dictionaryFromNSDictionaryJSON);
                self.delegate?.comeBackWithResponse(dictionaryFromNSDictionaryJSON)
            })
        
        task.resume()
    }
    
    //UNTESTED
    
    func POSTDataWithMultiPartForm (urlStringForConnection:String, httpBodyDictionary:Dictionary <String, NSData>, onCompletion: (response:Dictionary<NSObject,AnyObject>) -> Void){
        
        let sampleUrl : NSURL = .URLWithString(urlStringForConnection)
        let request = NSMutableURLRequest(URL: sampleUrl)
        let queue = NSOperationQueue()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        var localClassErrorNetworking: NSError?
        
        let boundary = "---------------------------14737809831466499882746641449"
        request.addValue("multipart/form-data \(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        var postBody:NSMutableData = NSMutableData.alloc()
        let boundaryWithLineAndCarriageReturns = "\r\n--\(boundary)\r\n"
        
        
        let keyArray:Array = Array(httpBodyDictionary.keys)
        let valueArray:Array = Array(httpBodyDictionary.values)
        
        
        for (var i = 0; i < keyArray.count; i++){
            let key:String = keyArray[i]
            let value:NSData = valueArray[i]
            postBody.appendData(boundaryWithLineAndCarriageReturns.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
            postBody.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\";".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
            postBody.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
            postBody.appendData(value)
            postBody.appendData(boundaryWithLineAndCarriageReturns.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        }
        
        request.HTTPBody = postBody
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest( request, completionHandler:{ (data : NSData!, response: NSURLResponse!, error : NSError!) -> Void in
            
            let byteString : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &localClassErrorNetworking) as NSDictionary
            
            let dictionaryFromNSDictionaryJSON:Dictionary = byteString
            onCompletion(response: dictionaryFromNSDictionaryJSON)
//            self.delegate?.comeBackWithResponse(dictionaryFromNSDictionaryJSON)
            })
        
        task.resume()
    }
}


