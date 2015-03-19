//
//  ViewController.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 2014/06/06.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

import UIKit

class StartButton: UIButton {
    let width:CGFloat  = APP_SIZE.width * 0.4
    let height:CGFloat = 60.0
    let nColor:Int     = 0x1179dd
    let nBGColor:Int   = 0xfff00
    let aColor:Int     = 0xfff00
    let aBGColor:Int   = 0x1179dd
    let radius:CGFloat = 20.0
    
    init(){
        super.init(frame: CGRectMake(0, 0, width, height))
        self.center = CGPointMake(APP_SIZE.width/2, APP_SIZE.height/2)
        self.setTitle("Start Game", forState: .Normal)
        self.setTitleColor(RGBA(self.nColor, 1.0), forState: .Normal)
        self.setTitleColor(RGBA(self.aColor, 1.0), forState: .Highlighted)
        
        self.backgroundColor = RGBA(self.nBGColor, 1.0)
        self.layer.cornerRadius = radius
        self.addTarget(self, action: Selector("stateChanged:event:"), forControlEvents: UIControlEvents.AllTouchEvents)
    }
    
    // タッチイベントの処理
    func stateChanged(sender:UIButton, event:UIEvent){
        
        var touch:AnyObject! = event.allTouches().anyObject()
        
        if(sender.highlighted && touch.phase != UITouchPhase.Ended){
            self.backgroundColor = RGBA(self.aBGColor, 1.0)
        }else{
            self.backgroundColor = RGBA(self.nBGColor, 1.0)
        }
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let startButton = StartButton()
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: Selector("startButtonTapped:"), forControlEvents: .TouchUpInside)
        
    }
    
    func startButtonTapped(sender:UIButton) {
        let gvc = GameViewController()
        self.presentViewController(gvc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

