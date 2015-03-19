import Foundation
import SpriteKit

@objc public class Smaple_SKPhysics : NSObject, MZPQueueActionElemnt, SKPhysicsContactDelegate {

    let spriteCategoryBitMask = 0x1 << 0 as UInt32

    let wallCategoryBitMask = 0x1 << 1 as UInt32

    public var scene: SKScene!

    public var title: String! = "SK 物理相關研究"

    public var isDone: Bool { get { return false } }

    public func start() {
//        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene.physicsWorld.contactDelegate = self
        scene.addChild(_testerLayer)

        scene.addChild(_debugLayer)

        _setWalls()
        _createSprites()
    }

    public func update(currentTime: NSTimeInterval) {
        _debugLayer.removeAllChildren()
    }

    public func didFinishUpdate() {
    }
    
    public func end() {
    }

    public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let pos = (touches.anyObject()! as UITouch).locationInNode(_testerLayer)
        let forceRect = CGRect(center: pos, size: CGSize(width: 20, height: 20))

        var body = scene.physicsWorld.bodyInRect(forceRect)
        body?.applyImpulse(CGVector(dx: 0, dy: 1))
    }


    // MARK: SKPhysicsContactDelegate

    public func didBeginContact(contact: SKPhysicsContact) {
    }



    // MARK: Private

    var _testerLayer = SKNode()

    var _debugLayer = SKNode()

    var _center: CGPoint { get { return CGPoint(size: scene.size / 2) } }

    private func _setWalls() {
        let poss = [
            _center + CGPoint(x: -160, y:    0),
            _center + CGPoint(x:  160, y:    0),
            _center + CGPoint(x:    0, y:  250),
            _center + CGPoint(x:    0, y: -250),
        ]

        let sizes = [
            CGSize(width: 5, height: 1000),
            CGSize(width: 5, height: 1000),
            CGSize(width: 1000, height: 5),
            CGSize(width: 1000, height: 5),
        ]

        for i in 0..<poss.count {
            var wall = SKSpriteNode(color: SKColor.yellowColor(), size: sizes[i])
            _testerLayer.addChild(wall)
            wall.position = poss[i]

            wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
            wall.physicsBody!.dynamic = false
            wall.physicsBody!.categoryBitMask = wallCategoryBitMask
        }
    }

    private func _createSprites() {
        let rangeX = 40...Int(scene.size.width - 40)
        let rangeY = Int(scene.size.height / 2)...Int(scene.size.height - 40)

        for i in 1...100 {
            let x = MZ.Maths.randomInt(rangeX)
            let y = MZ.Maths.randomInt(rangeY)

            _newSpriteAt(CGPoint(x: x, y: y))
        }
    }

    private func _newSpriteAt(position: CGPoint) {
        var sprite = SKSpriteNode(imageNamed: "bosslogo-sheet0")
        _testerLayer.addChild(sprite)
        sprite.position = position
        sprite.scale = MZ.Maths.randomFloat(min: 0.1, max: 0.25)
        sprite.color = SKColor(
            red:   MZ.Maths.randomFloat(min: 0.0, max: 1.0).toCGFloat(),
            green: MZ.Maths.randomFloat(min: 0.0, max: 1.0).toCGFloat(),
            blue:  MZ.Maths.randomFloat(min: 0.0, max: 1.0).toCGFloat(),
            alpha: 1
        )

        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width * 0.8 / 2)
        sprite.physicsBody!.friction           = 1.0
        sprite.physicsBody!.restitution        = 0.5
        sprite.physicsBody!.linearDamping      = 1.0
        sprite.physicsBody!.allowsRotation     = true
        sprite.physicsBody!.categoryBitMask    = spriteCategoryBitMask
        sprite.physicsBody!.contactTestBitMask = wallCategoryBitMask
    }
}