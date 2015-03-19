//
//  RSActionMenuViewController.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/08.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit

class RSActionMenuViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    struct ViewInfo {
        static let className = "RSActionMenuViewController"
        static let cellClassName = "RSActionMenuItemCell"
        static let cellIdentifier = "CellIdentifer"
    }
    
    @IBOutlet var overlayView: UIView
    @IBOutlet var tableView: UITableView
    var alertWindow: UIWindow?
    var itemList: RSActionMenuItem[]!
    var selectCallBack: ((Int) -> Void)?
    
    init(itemList: RSActionMenuItem[]!) {
        super.init(nibName: ViewInfo.className, bundle: nil)
        self.itemList = itemList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tableFrame = self.tableView.frame
        tableFrame.size.height = CGFloat(self.itemList.count) * self.tableView.rowHeight
        self.tableView.frame = tableFrame
        self.tableView.registerNib(UINib(nibName: ViewInfo.cellClassName, bundle: nil), forCellReuseIdentifier: ViewInfo.cellIdentifier)
        self.tableView.reloadData()
    }
    
    // MARK: UITableView DataSource
    func numberOfSectionsInTableView(_: UITableView) -> Int {
        return 1
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewInfo.cellIdentifier, forIndexPath: indexPath) as RSActionMenuItemCell
        let item = self.itemList[indexPath.row]
        cell.backgroundImageView.image = item.image
        cell.titleLabel.text = item.titleText
        cell.subLabel.text = item.subText
        return cell
    }
    
    // MARK: UITableView Delegate
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let callBack = self.selectCallBack {
            callBack(indexPath.row)
        }
        self.dismissAnimation()
    }
    

    // MARK: Animation
    func presentInViewController(viewController: UIViewController, selectCallBack callback: ((Int) -> Void)?) {
        self.alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.alertWindow!.windowLevel = UIWindowLevelAlert + 1
        self.alertWindow!.addSubview(self.view)
        self.alertWindow!.makeKeyAndVisible()
        
        viewController.addChildViewController(self)
        self.presentAnimation()
        
        self.selectCallBack = callback
    }
    
    func presentAnimation() {
        // setup overlay frame
        var overlayFrame = self.view.bounds
        self.overlayView.frame = overlayFrame
        self.overlayView.alpha = 0.0
        
        // setup table fame
        var tableFrame = self.tableView.frame
        tableFrame.origin.y = self.view.frame.size.height
        self.tableView.frame = tableFrame
        
        UIView.animateWithDuration(0.3,
                            delay: 0.0,
                            options: .CurveEaseOut ,
                            animations: {
                                overlayFrame.size.height -= self.tableView.frame.size.height
                                self.overlayView.frame = overlayFrame
                                self.overlayView.alpha = 0.5
                                self.tableView.frame = CGRectOffset(tableFrame, 0, -tableFrame.size.height)
                            },
                            completion: nil)
        
    }
    
    func dismissAnimation() {
        UIView.animateWithDuration(0.3,
                            delay: 0.0,
                            options: .CurveEaseIn,
                            animations: {
                                self.overlayView.frame = self.view.bounds
                                self.overlayView.alpha = 0.0

                                var tableFrame = self.tableView.frame
                                tableFrame.origin.y = self.view.frame.size.height
                                self.tableView.frame = tableFrame
                            },
                            completion: { (success: Bool) in
                                self.view.removeFromSuperview()
                                self.alertWindow = nil
                                self.selectCallBack = nil
                                self.removeFromParentViewController()
                            })
    }
    
    // MARK: Gesture
    
    @IBAction func handleTapOverlayView(gesture: UITapGestureRecognizer) {
        self.dismissAnimation()
    }
    
}
