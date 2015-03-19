//
//  ColorfulBar.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class ColorfulBar: UIView {
  private var topImageView: UIImageView?
  private var bottomImageView: UIImageView?
  private var image: UIImage?
  
  func setImage(image: UIImage?) {
    if (self.image == nil) {
      self.topImageView?.image = image
      self.image = image
    } else {
      self.bringSubviewToFront(self.bottomImageView!)
      self.bottomImageView?.image = image
      UIView.animateWithDuration(0.3, animations: {
        self.topImageView?.alpha = 0.5
        self.bottomImageView?.alpha = 1
      }, completion: { (Bool) -> Void in
        let tempImageVIew = self.topImageView
        self.topImageView = self.bottomImageView
        self.bottomImageView = tempImageVIew
      })
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.topImageView = UIImageView()
    self.bottomImageView = UIImageView()
    self.addSubview(self.topImageView!)
    self.addSubview(self.bottomImageView!)
    
    self.bottomImageView?.alpha = 0
  }
  
  override func layoutSubviews() {
    self.topImageView?.frame = self.bounds
    self.bottomImageView?.frame = self.bounds
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
