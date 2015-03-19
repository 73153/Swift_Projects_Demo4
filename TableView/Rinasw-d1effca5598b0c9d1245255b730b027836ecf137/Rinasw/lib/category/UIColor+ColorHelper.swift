//
//  UIColor+ColorHelper.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/03.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgbColorWithRed(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    class func hexColorWithString(hex: String, alpha: CGFloat) -> UIColor? {
        var colorCd = hex;
        if colorCd.substringToIndex(0) == "#" {
            colorCd = hex.substringFromIndex(1)
        }
        
        let colorScanner = NSScanner(string: colorCd)
        var color : CUnsignedInt = 0
        if !colorScanner.scanHexInt(&color) {
            return nil
        }
    
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((color & 0x00FF00) >> 8) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
