//
//  UIView+Hierarchy.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import UIKit

extension UIView {
    
    func superviewOfClass(requiredClass: AnyClass) -> UIView {
        if self.superview.isKindOfClass(requiredClass) {
            return self.superview
        }
        
        return self.superview.superviewOfClass(requiredClass)
    }
}

