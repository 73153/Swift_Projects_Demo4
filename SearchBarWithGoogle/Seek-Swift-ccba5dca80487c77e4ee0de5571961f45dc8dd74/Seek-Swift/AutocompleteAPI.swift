//
//  AutocompleteAPI.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/5/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import Foundation

class AutocompleteAPI {

    enum AutocompleteAPIResponse {
        case Results (String[])
        case Error (NSError)
    }
    
    let apiBaseURL = "http://suggestqueries.google.com/complete/search"
    let clientString = "firefox"
    var isDownloading = false
    
    @lazy var session: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: configuration)
        }()
    var downloader: NSURLSessionDataTask! {
        willSet {
            
            if (isDownloading) {
                downloader.cancel()
            }
            isDownloading = true
        }
    }
    
    init() {}
    
    func suggestionsForQuery(query: String, completion:(AutocompleteAPIResponse) -> () ) {
        let URL = URLForQuery(query)
        downloader = session.dataTaskWithURL(URL) { data, _, downloadError in
            self.isDownloading = false
            
            if downloadError {
                completion( .Error(downloadError!) )
                return
            }
            let (suggestions, parsingError) = self.parseJSON(data)
            
            if suggestions {
                completion( .Results(suggestions!) )
            }
            else if parsingError {
                completion( .Error(parsingError!) )
            }
            else {
                completion( .Error(NSError.noResultsFoundError()) )
            }
        }
        
        downloader.resume()
    }

    func URLForQuery(query: String) -> NSURL {
        let urlString = "\(apiBaseURL)?client=\(clientString)&q=\(query.escape())"
        return NSURL.URLWithString(urlString)
    }
    
    func parseJSON(data: NSData) -> (String[]?, NSError?) {
        var parseError: NSError?
        var suggestions: String[]?
        
        if let results: NSArray = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.AllowFragments, error: &parseError) as? NSArray {
            suggestions = results.lastObject as? String[]
        }
        return (suggestions, parseError)
    }
}