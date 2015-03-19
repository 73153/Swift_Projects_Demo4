import Foundation
import SpriteKit

@objc public class Sample_PhysicsJoint : NSObject, MZPQueueActionElemnt, SKPhysicsContactDelegate {

    let bulletCategory: UInt32 = 0x1 << 0

    let wallCategory: UInt32   = 0x1 << 1

    public var scene: SKScene!

    public var title: String! = ""

    public var isDone: Bool { get { return false } }

    public func start() {
        scene.addChild(_nodesLayer)
        scene.physicsWorld.gravity = CGVector.zeroVector

//        var s = _addNewArmObjectToNodesLayer()
        var s = _newLimitJoint()
        s.position = _center
    }

    public func update(currentTime: NSTimeInterval) {
        _time.update(currentTime: currentTime)
        _createBullets()
    }

    public func end() {}

    public func didBeginContact(contact: SKPhysicsContact) {}



    // MARK: Private

    private var _time = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Time, fps: 30)

    private var _nodesLayer = SKNode()

    private var _center: CGPoint { get { return CGPoint(size: scene.size / 2) } }

    private var _currentColddownCount: MZFloat = 0.0

    private func _addNewArmObjectToNodesLayer() -> SKNode {
        var node = SKNode()
        _nodesLayer.addChild(node)

        var base = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: 30, height: 30))
        node.addChild(base)
        _setPhysicsBodyToSprite(base)
        base.physicsBody!.dynamic = false

        var armInner = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 5, height: 80))
        node.addChild(armInner)
        _setPhysicsBodyToSprite(armInner)

        var armOutter = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 5, height: 40))
        node.addChild(armOutter)
        _setPhysicsBodyToSprite(armOutter)

        base.position = CGPoint.zero
        armInner.position.y = base.position.y + base.size.height / 2 + armInner.size.height / 2
        armOutter.position.y = armInner.position.y + armInner.size.height / 2 + armOutter.size.height / 2

        scene.physicsWorld.addJoint(SKPhysicsJointPin.jointWithBodyA(
            base.physicsBody!,
            bodyB: armInner.physicsBody!,
            anchor: CGPoint(x: 0, y: base.position.y + base.size.height / 2)
        ))

        scene.physicsWorld.addJoint(SKPhysicsJointPin.jointWithBodyA(
            armInner.physicsBody!,
            bodyB: armOutter.physicsBody!,
            anchor: CGPoint(x: 0, y: armInner.position.y + armInner.size.height / 2)
        ))

        base.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI * 2.0), duration: 1)))

        return node
    }

    private func _newLimitJoint() -> SKNode {
        var node = SKNode()
        _nodesLayer.addChild(node)

        var upper = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 100, height: 50))
        node.addChild(upper)
        _setPhysicsBodyToSprite(upper)

        var lower = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 100, height: 50))
        node.addChild(lower)
        _setPhysicsBodyToSprite(lower)

        upper.position.y = 100
        lower.position.y = -100

        scene.physicsWorld.addJoint(SKPhysicsJointLimit.jointWithBodyA(
            upper.physicsBody!,
            bodyB: lower.physicsBody!,
            anchorA: CGPoint(x: 0, y: upper.position.y - upper.size.height / 2),
            anchorB: CGPoint(x: 0, y: lower.position.y + lower.size.height / 2)
        ))

        return node
    }

    private func _createBullets() {
        let interval = 0.5

        if _time.passedTime > 3 { return }

        _currentColddownCount -= _time.deltaTime

        if _currentColddownCount > 0 { return }

        _currentColddownCount += interval

        for i in 1...10 { _randomCreateNewBullet() }
    }

    private func _randomCreateNewBullet() {
        let degree = MZ.Maths.randomFloat(min: 0, max: 360.0)
        let impulseDirection = MZ.Maths.randomFloat(min: 0, max: 360)
        let moveVector = MZ.Maths.unitVectorFromDegrees(impulseDirection).toCGVector() / 4
        var bullet = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 12, height: 4))
        bullet.name = "bullet"
        _nodesLayer.addChild(bullet)
        bullet.position = _center

        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.restitution = 1.0
        bullet.physicsBody!.allowsRotation = true
        bullet.physicsBody!.categoryBitMask = bulletCategory
        bullet.physicsBody!.collisionBitMask = wallCategory

        bullet.rotation = impulseDirection

        bullet.position = _center

        bullet.physicsBody!.applyImpulse(moveVector)
    }

    func _setPhysicsBodyToSprite(sprite: SKSpriteNode) {
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
    }
}
