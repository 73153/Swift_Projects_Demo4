//
//  Rope.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Rope: SKSpriteNode {
    let maxLength:CGFloat
    init(length:CGFloat){
        
        let texture = SKTexture(imageNamed: "rope")
        maxLength = texture.size().height/(texture.size().width/5)
        let size = CGSize(width: 5, height: min(length,maxLength))
        super.init(texture: SKTexture(rect: CGRect(origin: CGPointZero, size: CGSize(width: 1, height: min(length / maxLength, 1))), inTexture: texture),color:SKColor.clearColor(), size: size)
        
        
        
//        self.normalTexture = self.texture?.textureByGeneratingNormalMapWithSmoothness(0.5, contrast: 0.5)
//        self.lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|bgLightCategory|reaperLightCategory
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
