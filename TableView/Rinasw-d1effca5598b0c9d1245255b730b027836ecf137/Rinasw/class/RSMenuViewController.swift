//
//  RSMenuViewController.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/03.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit

class RSMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func touchedPlayMusicButton() {
        let viewController = RSMusicViewController()
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

