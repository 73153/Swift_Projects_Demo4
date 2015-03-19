//
//  ViewController.swift
//  BOHTTPRequestDemo
//
//  Created by Oleg Bogatenko on 09/06/2014.
//  Copyright (c) 2014 intelex LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sendRequest(AnyObject) {
        
        let r = BOHTTPRequest(url: "https://itunes.apple.com/lookup?id=909253")
        
        r.GET({(error: NSError?, headers: NSDictionary?, data: NSData?) -> () in
            
            if (error) {
                println("Error: \(error!.localizedDescription)")
            } else {
                
                var error: NSError?
                var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
                
                println("Recieved JSON: \(json)")
            }
        })
    }
}

