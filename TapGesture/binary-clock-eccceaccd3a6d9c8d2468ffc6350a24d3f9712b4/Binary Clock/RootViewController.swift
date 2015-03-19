//
//  RootViewController.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 05.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var color: UIColor
    var binClock: BinaryClock?
    var grid: Grid?

    init() {
        color = UIColor.whiteColor()
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.blackColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabled lock
        UIApplication.sharedApplication().idleTimerDisabled = false

        binClock = BinaryClock()
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                                                  selector: Selector("update"),
                                                  userInfo: nil,
                                                   repeats: true)
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("inverse"))
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func update() {
        if grid {
            grid!.removeFromSuperview()
        }
        
        grid = Grid(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height),
            matrix: binClock!.matrix,
            color: color)
        view.addSubview(grid)
    }
    
    func inverse() {
        if (color == UIColor.whiteColor()) {
            view.backgroundColor = UIColor.whiteColor()
            color = UIColor.blackColor()
        } else {
            view.backgroundColor = UIColor.blackColor()
            color = UIColor.whiteColor()
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
