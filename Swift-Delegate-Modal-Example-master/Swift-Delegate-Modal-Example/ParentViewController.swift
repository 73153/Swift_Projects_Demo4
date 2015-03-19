//
//  ParentViewController.swift
//  Swift-Delegate-Modal-Example
//
//  Created by Osamu Nishiyama on 2014/10/22.
//  Copyright (c) 2014年 ever sense. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, ModalViewControllerDelegate {

    let modalView = ModalViewController()
    let modalTextLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let showModalBtn = UIButton(frame: CGRectMake(0, 0, 300, 50))
        showModalBtn.layer.position = CGPoint(x: self.view.frame.width/2, y: 100)
        showModalBtn.setTitle("Show Modal", forState: .Normal)
        showModalBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        showModalBtn.addTarget(self, action: "showModal:", forControlEvents:.TouchUpInside)
        self.view.addSubview(showModalBtn)
        
        self.modalTextLabel.frame = CGRectMake(0, 0, 300, 50)
        self.modalTextLabel.layer.position = CGPoint(x: self.view.frame.width/2, y: 200)
        self.modalTextLabel.textAlignment = .Center
        self.modalTextLabel.text = "The Modal text is ..."
        self.modalTextLabel.textColor = UIColor.blackColor()
        self.view.addSubview(modalTextLabel)
        
        self.modalView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showModal(sender: AnyObject){
        self.presentViewController(self.modalView, animated: true, completion: nil)
    }

    func modalDidFinished(modalText: String){
        println(modalText)
        self.modalTextLabel.text = modalText
        self.modalView.dismissViewControllerAnimated(true, completion: nil)
    }
}

