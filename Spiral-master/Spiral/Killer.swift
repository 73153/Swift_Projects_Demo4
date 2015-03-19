//
//  Killer.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Killer: Shape {
    convenience init() {
        self.init(name:"Killer",imageName:"killer")
        self.physicsBody!.categoryBitMask = killerCategory
        light.lightColor = SKColor.redColor()
        light.categoryBitMask = killerLightCategory
//        light.enabled = true
    }
}
