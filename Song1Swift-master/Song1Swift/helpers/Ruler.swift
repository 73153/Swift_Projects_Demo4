//
//  Ruler.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

class Ruler: NSObject {
  class func windowWidth() -> CGFloat {
    return UIScreen.mainScreen().bounds.width
  }
  
  class func windowHeight() -> CGFloat {
    return UIScreen.mainScreen().bounds.height
  }
  
  class func rectBaseWidth(source: CGRect, newHeight: CGFloat) -> CGRect {
    return CGRect(x: source.origin.x, y: source.origin.y, width: source.width, height: newHeight)
  }
}
