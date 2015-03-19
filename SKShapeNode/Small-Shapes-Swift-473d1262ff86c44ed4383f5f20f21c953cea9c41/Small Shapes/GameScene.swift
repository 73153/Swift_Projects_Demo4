//
//  GameScene.swift
//  Small Shapes
//
//  Created by Hamdan Javeed on 2014-06-03.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var player: SKShapeNode!
    
    var turnRight = false;
    var turnLeft = false;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"HelveticaNeue-UltraLight")
        
        myLabel.text = "Small Shapes";
        myLabel.fontSize = 24;
        myLabel.position = CGPoint(x:75, y:view.frame.height - 30);
        
        self.addChild(myLabel)
        
        player = SKShapeNode(circleOfRadius: 20);
        player.name = "Player"
        player.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        player.fillColor = SKColor.orangeColor()
        player.strokeColor = SKColor.clearColor()
        
        let notch = SKShapeNode(rectOfSize: CGSizeMake(4, 4))
        notch.position = CGPointMake(0, 18)
        notch.fillColor = SKColor.blackColor()
        notch.strokeColor = SKColor.clearColor()
        player.addChild(notch);
        
        player.setScale(1.3)
        
        var grow = SKAction.scaleTo(1.3, duration: 1)
        var shrink = SKAction.scaleTo(0.2, duration: 1)
        
        var colorToGrey = SKAction.runBlock({
            self.player.fillColor = SKColor.grayColor()
            self.backgroundColor = SKColor.orangeColor()
        });
        
        var colorToOrange = SKAction.runBlock({
            self.player.fillColor = SKColor.orangeColor()
            self.backgroundColor = SKColor.grayColor()
        });
        
        var g1 = SKAction.group([grow, colorToOrange])
        var g2 = SKAction.group([shrink, colorToGrey])
        
        let leftButton = SKShapeNode(rect: CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width / 2, view.frame.height))
        leftButton.name = "left"
        leftButton.strokeColor = SKColor.clearColor()
        let rightButton = SKShapeNode(rect: CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width / 2, view.frame.height))
        rightButton.name = "right"
        rightButton.strokeColor = SKColor.clearColor()
        rightButton.position = CGPointMake(view.frame.width / 2, rightButton.position.y)
        
        self.addChild(player)
        self.addChild(leftButton)
        self.addChild(rightButton)
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([g1, g2])))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "left" {
                    turnLeft = true;
                    turnRight = false;
                } else if name == "right" {
                    turnRight = true;
                    turnLeft = false;
                } else {
                    println("No name!")
                }
            } else {
                println("No Node!")
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if let name = node.name {
                if name == "left" || name == "right" {
                    turnLeft = false;
                    turnRight = false;
                } else {
                    println("No name!")
                }
            } else {
                println("No Node!")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if turnRight {
            player.zRotation -= 0.05;
        } else if turnLeft {
            player.zRotation += 0.05;
        }
    }
}
