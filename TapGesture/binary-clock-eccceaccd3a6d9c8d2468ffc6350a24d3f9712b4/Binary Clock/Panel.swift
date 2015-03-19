//
//  Panel.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 06.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import UIKit

class Panel: UIView {
    
    let margin: Int?

    init(frame: CGRect, color: UIColor = UIColor.blackColor(), margin: Int = 0) {
        super.init(frame: frame)
        
        if (margin == 0) {
            backgroundColor = color
        } else {
            self.margin = margin

            let paddingFloat = CGFloat(margin)
            var subView = UIView(frame: CGRect(x: paddingFloat,
                                               y: paddingFloat,
                                           width: frame.size.width  - paddingFloat * 2.0,
                                          height: frame.size.height - paddingFloat * 2.0))
            subView.backgroundColor = color
            addSubview(subView)
        }
    }

}

