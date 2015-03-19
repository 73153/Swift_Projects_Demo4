//
//  WebViewController.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/3/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit

class WebViewController: UIViewController
{
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibName, bundle: nibBundleOrNil)
        // Custom initialization
        self.hidesBottomBarWhenPushed = true
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func setURL(url: String)
    {
        let webview: UIWebView = UIWebView(frame: CGRectZero)
        view = webview
        webview.scalesPageToFit = true
        
        let weburl : NSURL = NSURL.URLWithString(url)
        let request: NSURLRequest = NSURLRequest(URL: weburl)
        webview.loadRequest(request)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}
