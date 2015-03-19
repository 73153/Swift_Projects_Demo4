//
//  WebController.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/9/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {
    var webView: JCSWebView!
    var URL: NSURL!
    
    class func webControllerWithURL(URL: NSURL) -> WebController {
        let webController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("WebController") as WebController
        webController.URL = URL
        return webController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func setupWebView() {
        webView = JCSWebView(frame: CGRect(x: 0, y: 20.0, width: view.bounds.width, height: view.bounds.height))
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        let request = NSURLRequest(URL: URL)
        webView.loadRequest(request)

    }
}