//
//  ModalViewController.swift
//  Swift-Delegate-Modal-Example
//
//  Created by Osamu Nishiyama on 2014/10/22.
//  Copyright (c) 2014年 ever sense. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate{
    func modalDidFinished(modalText: String)
}

class ModalViewController: UIViewController {

    var delegate: ParentViewController! = nil
    let text1 = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.orangeColor()
        
        self.text1.frame = CGRectMake(0, 0, 150, 50)
        self.text1.layer.position = CGPoint(x: self.view.frame.width/2, y:100)
        self.text1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.text1)
        
        let submitBtn = UIButton(frame: CGRectMake(0, 0, 300, 50))
        submitBtn.layer.position = CGPoint(x: self.view.frame.width/2, y:200)
        submitBtn.setTitle("Submit", forState: .Normal)
        submitBtn.addTarget(self, action: "submit:", forControlEvents: .TouchUpInside)
        self.view.addSubview(submitBtn)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submit(sender: AnyObject) {
        self.delegate.modalDidFinished(self.text1.text)
    }
}
