//
//  GameScene.swift
//  RockPaperSwift
//
//  Created by Christian Hansen on 6/3/14.
//  Copyright (c) 2014 Christian Hansen. All rights reserved.
//

import SpriteKit

var myScoreInt = 0
var opponentScoreInt = 0

var myScore = SKLabelNode(text: "0")
var opponentScore = SKLabelNode(text: "0")

let opponentThrow = SKLabelNode(text: "")

var throwIsValid = true
var temp = true

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // terrible, awful, hack to avoid figuring out why app crashes when anywhere in the background was tapped. Fix this, dipshit.
        // remove transparent background image, tap anywhere other than a sklabelnode and get "Can't unwrap Optional.None" error / crash.
        let backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
        backgroundImage.name = "background"
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        backgroundImage.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        let rockLabelNode = SKLabelNode(text: "Rock")
        rockLabelNode.fontSize = 32
        rockLabelNode.name = "Rock"
        rockLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rockLabelNode.position = CGPointMake(CGRectGetMidX(self.frame)-120.0, CGRectGetMidY(self.frame)-200.0)
        self.addChild(rockLabelNode)
        
        let paperLabelNode = SKLabelNode(text: "Paper")
        paperLabelNode.fontSize = 32
        paperLabelNode.name = "Paper"

        paperLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200.0)
        self.addChild(paperLabelNode)
        
        let scissorsLabelNode = SKLabelNode(text: "Scissors")
        scissorsLabelNode.fontSize = 32
        scissorsLabelNode.name = "Scissors"

        scissorsLabelNode.position = CGPointMake(CGRectGetMidX(self.frame)+120.0, CGRectGetMidY(self.frame)-200.0)
        self.addChild(scissorsLabelNode)
        
        let startLabelNode = SKLabelNode(text: "Start")
        startLabelNode.fontSize = 32
        startLabelNode.name = "Start"
        
        startLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-200.0)
        self.addChild(startLabelNode)
        
        myScore.fontSize = 32
        myScore.position = CGPointMake(CGRectGetMidX(self.frame) - 150.0, CGRectGetMidY(self.frame)+250)
        
        opponentScore.fontSize = 32
        opponentScore.position = CGPointMake(CGRectGetMidX(self.frame) + 150.0, CGRectGetMidY(self.frame)+250)
        self.addChild(myScore)
        self.addChild(opponentScore)
        

    }
    
    func countdown() {
        println("Start pressed")
        
        let i = randomThrow()
        
        let timer = SKLabelNode(text: "3")
        timer.fontSize = 100
        timer.alpha = 0
        timer.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(timer)
        
        let timer2 = SKLabelNode(text: "2")
        timer2.fontSize = 100
        timer2.alpha = 0
        timer2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(timer2)
        
        let timer1 = SKLabelNode(text: "1")
        timer1.fontSize = 100
        timer1.alpha = 0
        timer1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(timer1)
        
        var stringFromRandom = ""
        
        if i == 0 {
            println("threw 0")
            stringFromRandom = "Rock"
        } else if i == 1 {
            println("threw 1")
            stringFromRandom = "Paper"
        } else if i == 2 {
            println("threw 2")
            stringFromRandom = "Scissors"
        }
        
        opponentThrow.text = stringFromRandom
        opponentThrow.fontSize = 100
        opponentThrow.alpha = 0
        opponentThrow.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(opponentThrow)
        
        var threeSequence = SKAction.sequence([SKAction.fadeInWithDuration(0.3), SKAction.waitForDuration(0.1), SKAction.removeFromParent()])
        var twoSequence = SKAction.sequence([SKAction.waitForDuration(0.7), threeSequence])
        var oneSequence = SKAction.sequence([SKAction.waitForDuration(1.4), threeSequence])
        var throwSequence = SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.fadeInWithDuration(0.3), SKAction.waitForDuration(0.3), SKAction.removeFromParent()])
        
        timer.runAction(threeSequence)
        timer2.runAction(twoSequence)
        timer1.runAction(oneSequence)
        opponentThrow.runAction(throwSequence)
    }
    
    func randomThrow() -> UInt32 {
        let randomNumber = arc4random()%3
        return randomNumber;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if opponentThrow.parent {
                throwIsValid = true
            } else {
                println("No parent, skspritenode has been removed")
                throwIsValid = false
            }
            
            // Get the user's throw choice and compare it to see if it beats, loses or ties the opponent
            if touchedNode.name == opponentThrow.text && throwIsValid{
                println("Throw is valid and it matches - tie")
            } else if touchedNode.name == "Rock" && opponentThrow.text == "Scissors" && throwIsValid {
                println("Rock pressed and throw is valid and Scissors - Win")
                ++myScoreInt
            } else if touchedNode.name == "Scissors" && opponentThrow.text == "Paper" && throwIsValid {
                println("Scissors pressed, throw is valid and Paper - Win")
                ++myScoreInt
            } else if touchedNode.name == "Paper" && opponentThrow.text == "Rock" && throwIsValid {
                println("Paper pressed, throw is valid and Rock - Win")
                ++myScoreInt
            } else if touchedNode.name == "Start" {
                countdown()
            } else if touchedNode.name == "background" {
                
            }
            else {
                println("lose")
                ++opponentScoreInt
            }

            myScore.text = "\(myScoreInt)"
            opponentScore.text = "\(opponentScoreInt)"

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
