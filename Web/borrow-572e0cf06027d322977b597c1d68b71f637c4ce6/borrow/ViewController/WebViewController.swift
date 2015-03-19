//
//  WebViewController.swift
//  borrow
//
//  Created by markus on 04.06.14.
//
//

import UIKit
import WebKit

class WebViewController : UIViewController{

    @IBOutlet var containerView : UIView = nil
    @IBOutlet var backButton : UIBarButtonItem
    @IBOutlet var forwardButton : UIBarButtonItem
    @IBOutlet var reloadButton : UIBarButtonItem
    
    var webView : WKWebView = WKWebView()
    var progressView : UIProgressView = UIProgressView(progressViewStyle:.Bar)
    var url : NSURL?
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var req = NSURLRequest(URL: url)
        webView.loadRequest(req)
        
        // Progress
        self.setUpProgressView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.setToolbarHidden(false, animated: animated)
        
        // KVO
        let options = NSKeyValueObservingOptions.Initial | NSKeyValueObservingOptions.New
        webView.addObserver(self, forKeyPath: "title", options:options, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options:options, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options:options, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool){
        // Remove KVO
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer){
        if(keyPath == "loading"){
            let loading:Bool = change.objectForKey("new") as Bool
            if(loading){
                self.title = NSLocalizedString("Loading ...", comment: "")
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
            backButton.enabled = loading ? false : webView.canGoBack
            forwardButton.enabled = loading ? false : webView.canGoForward
            
            // Exchange buttons
            var toolbarItemsNew = toolbarItems as Array
            toolbarItemsNew.removeLast()
            
            var barButtonItem : UIBarButtonItem?
            if(loading){
                barButtonItem = UIBarButtonItem(barButtonSystemItem:.Stop, target: self, action:Selector("webViewStopLoading:"))
            } else {
                barButtonItem = UIBarButtonItem(barButtonSystemItem:.Refresh, target: self, action:Selector("webViewPerformReload:"))
            }
            toolbarItemsNew.append(barButtonItem!)
            toolbarItems = toolbarItemsNew
            
        } else if (keyPath == "estimatedProgress"){
            let progress:Double = change.objectForKey("new") as Double
            self.setProgress(progress)
        } else if (keyPath == "title"){
            let title = change.objectForKey("new") as String
            self.title = countElements(title) > 0 ? title : ""
        }
    }
    
    // MARK: - Progress
    func setUpProgressView(){
        self.navigationController.view.addSubview(progressView)
        let navigationBar = navigationController.navigationBar;
        
        self.navigationController.view.addConstraint(NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem:navigationBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -0.5))
        
        self.navigationController.view.addConstraint(NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:navigationBar, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        self.navigationController.view.addConstraint(NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setProgress(progress: Double){
        progressView.setProgress(CFloat(progress), animated: true);
        if(progress == 0.0 || progress == 1.0){
            UIView.animateWithDuration(0.2, delay: 0.2, options:UIViewAnimationOptions.CurveEaseOut, animations: {()-> Void in
                self.progressView.hidden = true;
            }, completion:nil)
        }
    }
    
    // MARK: - IBActions
    @IBAction func webViewNavigate(barButtonItem : UIBarButtonItem) {
        if(barButtonItem.tag == 0){
            if(webView.canGoBack){
                webView.goBack()
            }
        } else {
            if(webView.canGoForward){
                webView.goForward()
            }
        }
    }
    
    @IBAction func webViewPerformReload(sender : AnyObject) {
        webView.reload()
    }
    
    @IBAction func webViewStopLoading(sender : AnyObject) {
        webView.stopLoading()
    }
    
    @IBAction func share(sender : AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [webView.URL], applicationActivities:[UIActivityTypeOpenWithSafari(), UIActivityTypeOpenWithChrome()])
        presentViewController(activityViewController, animated: true, completion:nil)
    }
    
    @IBAction func dismiss(sender : AnyObject) {
        navigationController.dismissModalViewControllerAnimated(true);
    }
    
}