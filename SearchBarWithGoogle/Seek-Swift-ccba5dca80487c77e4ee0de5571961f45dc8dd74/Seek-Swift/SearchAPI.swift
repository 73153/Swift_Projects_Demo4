//
//  SearchAPI.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/7/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import Foundation

class SearchAPI: NSObject {
    
    enum SearchAPIResponse {
        case Results (WebResult[])
        case Error (NSError)
    }
    
    let BingAPIBaseURL = "https://api.datamarket.azure.com/Bing/Search/"
    let BingMarketString = "en-us"
    
    @lazy var session: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": self.authorizationHeader]
        return NSURLSession(configuration: configuration)
    }()
    @lazy var authorizationHeader: String = {
        let bingAccountKey = "akhwO6KR36BNXHQfN3mkvm54ZilO06GhnjiyXiGb1L8"
        let authKey = "\(bingAccountKey):\(bingAccountKey)"
        let UTF8KeyData = authKey.dataUsingEncoding(NSUTF8StringEncoding)
        return "Basic \(UTF8KeyData.base64Encoding())"
    }()

    func searchWithQuery(query: String, completion:(SearchAPIResponse) -> () ) {
        let URL = searchURLForQuery(query)
        let searchTask = session.dataTaskWithURL(URL) { data, _, downloadError in
            
            if (downloadError) {
                completion( .Error(downloadError) )
                return
            }
            let (webResults, parsingError) = self.parseJSON(data)

            if (webResults.count > 0) {
                completion( .Results(webResults) )
            }
            else if (parsingError) {
                completion( .Error(parsingError!) )
            }
            else {
                completion( .Error(NSError.noResultsFoundError()) )
            }
        }
        searchTask.resume()
        
    }
    
    func searchURLForQuery(query: String) -> NSURL {
        return NSURL.URLWithString("\(BingAPIBaseURL)/Web?"
            + "$format=JSON"
            + "&Query='\(query.escape())'"
            + "&Market='\(BingMarketString.escape())'"
            + "&$top=\(20)")
    }

    func parseJSON(data: NSData) -> (WebResult[], NSError?) {
        var parseError: NSError?
        var searchResults = WebResult[]()
        
        let parsedJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) as NSDictionary
        let results = parsedJSON.valueForKeyPath("d.results") as Dictionary<String, String>[]
        
        for result in results {
            let webResult = WebResult(JSONDictionary: result)
            searchResults.append(webResult)
        }
        return (searchResults, parseError)
    }
}