//
//  WebResult.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/7/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import Foundation

struct WebResult {
    let title: String
    let URL: NSURL
    let resultDescription: String
    
    init(JSONDictionary: Dictionary<String, String>) {
        title = JSONDictionary["Title"]!
        let urlString = JSONDictionary["Url"]!
        URL = NSURL.URLWithString(urlString)
        resultDescription = JSONDictionary["Description"]!
    }
}

extension WebResult: Printable {
    var description: String {
    return "[WebResult] \(title): \(resultDescription), via (\(URL.description))"
    }
}