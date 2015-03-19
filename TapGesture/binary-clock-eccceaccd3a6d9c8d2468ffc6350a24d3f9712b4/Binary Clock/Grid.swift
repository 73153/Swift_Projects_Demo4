//
//  Grid.swift
//  Binary Clock
//
//  Created by Arne Bahlo on 06.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//

import UIKit

class Grid: UIView {
    
    var matrix: (Bool[][])?
    let color: UIColor
    
    init(frame: CGRect, matrix: Bool[][], color: UIColor) {
        self.color = color
        self.matrix = matrix

        super.init(frame: frame)
        
        draw()
    }
    
    init() {
        self.color = UIColor.blackColor()
        self.matrix = Bool[][]()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func draw() {
        if !matrix || matrix!.isEmpty {
            // No need to do anything
            return
        }

        let panelSize      = (self.frame.size.width  / CGFloat(matrix![0].count),
                              self.frame.size.height / CGFloat(matrix!.count))
        
        var panel: Panel
        for i in 0..matrix!.count {
            for j in 0..matrix![i].count {
                if (matrix![i][j]) {
                    panel = Panel(frame: CGRect(x: CGFloat(j) * panelSize.0,
                                                y: CGFloat(i) * panelSize.1,
                                            width: panelSize.0,
                                           height: panelSize.1
                                         ), color: color,
                                           margin: 4)

                    addSubview(panel)
                }
            }
        }
    }

}
