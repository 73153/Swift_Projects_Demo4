//
//  Common.swift
//  Hack2048
//
//  Created by Kohei Iwasaki on 2014/06/06.
//  Copyright (c) 2014年 Kohei Iwasaki. All rights reserved.
//

import UIKit

let APP_SIZE = UIScreen.mainScreen().applicationFrame.size

func RGBA(rgb:Int, alpha:CGFloat) -> UIColor{
    return UIColor(
          red:CGFloat((rgb & 0xFF0000) >> 16)/255,
        green:CGFloat((rgb & 0x00FF00) >> 8)/255,
         blue:CGFloat(rgb & 0x0000FF)/255,
        alpha:alpha
    )
}

class Common: NSObject {
    
}
