//
//  NetworkManager.swift
//  Quoridor
//
//  Created by Konrad Szczesniak on 16/06/14.
//  Copyright (c) 2014 EL Passion. All rights reserved.
//

import Foundation

let NetworkManagerMethodPOST = "POST"
let NetworkManagerMethodGET = "GET"

class NetworkManager
{
    let serverUrl = "http://vielengamesapi.apiary-mock.com/"
    
    func request(method:String,
        path:String,
        parameters:Dictionary<String, AnyObject>?,
        successClosure:(AnyObject!) -> (Void),
        errorClosure:(AnyObject!, NSError) -> (Void))
    {
        let url = NSURL(string: serverUrl + path)
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) in
				var serializationError:NSError?
				let responseDictionary:AnyObject! = NSJSONSerialization.JSONObjectWithData(
					data,
					options: NSJSONReadingOptions.AllowFragments,
					error:&serializationError)
				
				if serializationError
				{
					errorClosure(nil, serializationError!)
				}
				else if error
                {
                    errorClosure(responseDictionary, error)
                }
                else
                {
                    successClosure(responseDictionary)
                }
            })
    }
}