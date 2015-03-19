//
//  MiniPlayView.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class MiniPlayView : UIView {
  var albumArtView: UIImageView?
  var playSection: UIView?
  var deviceSection: UIView?
  var titleLabel: UILabel?
  var subtitleLabel: UILabel?
  var playButton: UIButton?
  var pauseButton: UIButton?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.blackColor()
    self.albumArtView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    self.albumArtView?.backgroundColor = UIColor.grayColor()
    self.addSubview(self.albumArtView!)
    
    self.playSection = UIView(frame: CGRect(x: 50, y: 0, width: 53, height: 50))
    self.addSubview(self.playSection!)
    
    self.playButton = UIButton(frame: self.playSection!.bounds)
    self.playButton?.setImage(UIImage(named: "miniplay-paly-btn"), forState: .Normal)
    self.playButton?.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
    self.playSection?.addSubview(self.playButton!)
    
    self.pauseButton = UIButton(frame: self.playSection!.bounds)
    self.pauseButton?.setImage(UIImage(named: "miniplay-pause-btn"), forState: .Normal)
    self.pauseButton?.hidden = true
    self.pauseButton?.addTarget(self, action: "pause", forControlEvents: .TouchUpInside)
    self.playSection?.addSubview(self.pauseButton!)
    
    var divider = UIView(frame: CGRect(x: 50 + 53, y: 0, width: 0.5, height: 50))
    divider.backgroundColor = UIColor.hexColor(0x444343, alpha: 0.6)
    self.addSubview(divider)
    
    let right = frame.size.width
    
    self.deviceSection = UIView(frame: CGRect(x: right - 64, y: 0, width: 64, height: 50))
    self.addSubview(self.deviceSection!)
    
    var divider2 = UIView(frame: CGRect(x: right - 64.5, y: 0, width: 0.5, height: 50))
    divider2.backgroundColor = UIColor.hexColor(0x444343, alpha: 0.6)
    self.addSubview(divider2)
    
    let titleLeft = divider.frame.origin.x + divider.frame.size.width + 12
    let titleRight = divider2.frame.origin.x - 12
    
    self.titleLabel = UILabel(frame: CGRect(x: titleLeft, y: 10, width: titleRight - titleLeft, height: 16))
    self.titleLabel?.textColor = UIColor.whiteColor()
    self.titleLabel?.text = "Money On My Minxxxxx"
    self.titleLabel?.font = UIFont.systemFontOfSize(13)
    self.addSubview(self.titleLabel!)
    
    self.subtitleLabel = UILabel(frame: CGRect(x: titleLeft, y: 10 + 16 + 4, width: titleRight - titleLeft, height: 11))
    self.subtitleLabel?.textColor = UIColor.hexColor(0xffffff, alpha: 0.6)
    self.subtitleLabel?.font = UIFont.systemFontOfSize(11)
    self.subtitleLabel?.text = "Sam Smith"
    self.addSubview(self.subtitleLabel!)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func play() {
    self.playButton?.hidden = true
    self.pauseButton?.hidden = false
  }
  
  func pause() {
    self.playButton?.hidden = false
    self.pauseButton?.hidden = true
  }
}
