//
//  JCSWebView.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/9/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit
import QuartzCore
import WebKit

// Extends WKWebView to show loading indicator
class JCSWebView: WKWebView {
    var loadingIndicator: ProgressView!
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, configuration: WKWebViewConfiguration!) {
        super.init(frame: frame, configuration: configuration)
        setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        let loadingIndicatorFrame = CGRect(x: 0, y: -2.0, width: bounds.width, height: 2.0)
        loadingIndicator = ProgressView(frame: loadingIndicatorFrame, color: Appearance.blueColor)
        addSubview(loadingIndicator)
        addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer) {
        
        if keyPath == "estimatedProgress" {
            let updatedProgress = change[NSKeyValueChangeNewKey] as Float
            loadingIndicator.progress = updatedProgress
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

class ProgressView: UIView {
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        backgroundColor = color
        configureMask()
    }
    
    func configureMask() {
        var maskFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: bounds.height)
        layer.mask = CALayer()
        layer.mask.frame = maskFrame
        layer.mask.backgroundColor = UIColor.whiteColor().CGColor
    }
    
    func updateProgress() {
        layer.mask.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(progress) * bounds.width, height: bounds.height)

        if progress > 0.0 && progress < 1.0 {
            hidden = false
        }
        if progress == 1.0 {
            showProgressCompleted()
        }
    }

    func showProgressCompleted() {
        UIView.animateWithDuration(0.3, delay: 0.2, options: nil,
            animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.hidden = true
                self.alpha = 1.0
                self.progress = 0.0
            })
    }
}