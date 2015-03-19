//
//  MainTabBar.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class MainTabBar: UIView {
  var mineButton: UIButton?
  var findButton: UIButton?
  var highlightView: UIView?
  var selectedBlock: ((Int) -> Void)?
  var selectedItem: Int = 0 {
    willSet(newItem) {
      if newItem == 0 {
        self.mineButton?.enabled = false
        self.findButton?.enabled = true
        self.highlightView?.center = CGPoint(x: self.mineButton!.center.x, y: self.highlightView!.center.y)
      } else if newItem == 1 {
        self.mineButton?.enabled = true
        self.findButton?.enabled = false
        self.highlightView?.center = CGPoint(x: self.findButton!.center.x, y: self.highlightView!.center.y)
      }
      if let block = self.selectedBlock {
        block(newItem)
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.mineButton = UIButton()
    self.mineButton?.setTitle("我的", forState: .Normal)
    self.initButton(self.mineButton!)
    self.mineButton?.sizeToFit()
    self.mineButton?.enabled = false
    self.addSubview(self.mineButton!)
    
    self.findButton = UIButton()
    self.findButton?.setTitle("发现", forState: .Normal)
    self.initButton(self.findButton!)
    self.findButton?.sizeToFit()
    self.addSubview(self.findButton!)
    
    self.highlightView = UIView()
    self.highlightView?.backgroundColor = UIColor.whiteColor()
    self.highlightView?.frame = CGRect(x: 0, y: 44 - 2, width: 60, height: 2)
    self.addSubview(self.highlightView!)
  }
  
  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    let width = self.bounds.size.width;
    let height = self.bounds.size.height;
    
    self.mineButton?.center = CGPoint(x: width / 2 - width / 4, y: height / 2 - 1)
    self.findButton?.center = CGPoint(x: width / 2 + width / 4, y: height / 2 - 1)
    if (self.mineButton!.enabled) {
      self.highlightView?.center = CGPoint(x: self.findButton!.center.x, y: self.highlightView!.center.y)
    } else {
      self.highlightView?.center = CGPoint(x: self.mineButton!.center.x, y: self.highlightView!.center.y)
    }
  }
  
  func onTap(sender: AnyObject) {
    let button = sender as UIButton
    if (button == self.mineButton) {
      self.selectedItem = 0
    } else {
      self.selectedItem = 1
    }
  }
  
  func whenTabSelected(newSelectBlock: (Int) -> Void) {
    self.selectedBlock = newSelectBlock
    newSelectBlock(self.selectedItem)
  }
  
  private func initButton(button: UIButton) {
    button.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
    button.setTitleColor(UIColor.hexColor(0xffffff, alpha: 0.5), forState: .Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(17)
    button.addTarget(self, action: Selector("onTap:"), forControlEvents: .TouchUpInside)
  }
}
