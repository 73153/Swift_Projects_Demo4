//
//  Shape.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit

class Shape: SKSpriteNode {
    var radius:CGFloat = 10
    var moveSpeed:CGFloat = 60
    var lineNum = 0
    let speedUpBase:CGFloat = 50
    var light = SKLightNode()
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(name:String,imageName:String){
        
        super.init(texture: SKTexture(imageNamed: imageName),color:SKColor.clearColor(), size: CGSizeMake(radius*2, radius*2))
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.contactTestBitMask = playerCategory|killerCategory|scoreCategory|shieldCategory|reaperCategory
        moveSpeed += Data.speedScale * speedUpBase
        self.name = name
        self.physicsBody!.angularDamping = 0
        self.normalTexture = self.texture?.textureByGeneratingNormalMap()
        light.enabled = false
        self.addChild(light)
    }
    
    func runInMap(map:Map){
        let distance = calDistanceInMap(map)
        let duration = distance/moveSpeed
        let rotate = SKAction.rotateByAngle(distance/10, duration: Double(duration))
        let move = SKAction.moveTo(map.points[lineNum+1], duration: Double(duration))
        let group = SKAction.group([rotate,move])
        self.runAction(group, completion: {
            self.lineNum++
            if self.lineNum==map.points.count-1 {
                if self is Player{
                    Data.gameOver = true
                }
                else{
                    self.removeFromParent()
                }
            }
            else {
                self.runInMap(map)
            }
            })
    }
    
    func calDistanceInMap(map:Map)->CGFloat{
        if self.lineNum==map.points.count {
            return 0
        }
        switch lineNum%4{
        case 0:
            return position.y-map.points[lineNum+1].y
        case 1:
            return position.x-map.points[lineNum+1].x
        case 2:
            return map.points[lineNum+1].y-position.y
        case 3:
            return map.points[lineNum+1].x-position.x
        default:
            return 0
        }
    }
    

}
