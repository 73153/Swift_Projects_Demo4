//
//  ColorHelper+UIColor.swift
//  Song1Swift
//
//  Created by Abner Zhong on 14/10/21.
//  Copyright (c) 2014年 song1.com. All rights reserved.
//

import UIKit

extension UIColor {
  class func hexColor(hex: Int, alpha: Double = 1.0) -> UIColor {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF)) / 255.0
    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha) )
  }
}
