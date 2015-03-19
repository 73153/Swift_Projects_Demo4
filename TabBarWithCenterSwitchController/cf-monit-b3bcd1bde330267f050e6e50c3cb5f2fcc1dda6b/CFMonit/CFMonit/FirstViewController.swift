//
//  FirstViewController.swift
//  CFMonit
//
//  Created by dr.max on 6/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
                            
    @IBOutlet var appName : UILabel
    @IBOutlet var appStatus : UILabel
    @IBOutlet var appStatusTimestamp : UILabel
    
    @IBOutlet var refreshButton : UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshTouched(sender : AnyObject) {
    }
}

