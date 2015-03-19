import Foundation
import SpriteKit

@objc public class Sample_PhysicsField : NSObject, MZPQueueActionElemnt, SKPhysicsContactDelegate {

    public var scene: SKScene!

    public var title: String! = ""

    public var isDone: Bool { get { return false } }

    public func start() {
        _center = CGPoint(size: scene.size / 2)

        scene.physicsWorld.gravity = CGVector.zeroVector
        scene.addChild(_testLayer)

        _setFields()
    }

    public func update(currentTime: NSTimeInterval) {
        _time.update(currentTime: currentTime)

        if _time.passedTime <= 3 { _createSprites() }
    }

    public func end() {
    }

    public func didBeginContact(contact: SKPhysicsContact) {
    }



    // MARK: Private

    private var _testLayer = SKNode()

    private var _center: CGPoint!

    private var _spawnCount: MZFloat = 0

    private var _time = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Time, fps: 30)

    private func _setFields() {
        let regionRadius: CGFloat = 80

        var field = SKFieldNode.springField()
        _testLayer.addChild(field)

        field.position = _center
        field.categoryBitMask = 0x1 << 1

        field.region = SKRegion(radius: regionRadius.toFloat())
        field.strength = 1.25 / 6
        field.falloff = -1

        var fieldShape = SKShapeNode(circleOfRadius: regionRadius)
        _testLayer.addChild(fieldShape)
        fieldShape.position = field.position
        fieldShape.fillColor = SKColor(red: 0.5, green: 0.5, blue: 0, alpha: 0.5)
    }

    private func _createSprites() {
        let interval: MZFloat = 0.5

        _spawnCount -= _time.deltaTime

        if _spawnCount > 0 { return }

        _spawnCount += interval

        for i in 1...50 { _createSprite() }
    }

    private func _createSprite() {
        var s = SKSpriteNode(color: SKColor.purpleColor(), size: CGSize(width: 6, height: 6))
        _testLayer.addChild(s)

        s.position = _center
        s.position.y = scene.size.height - 20

        s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size)

        s.physicsBody!.categoryBitMask = 0x1 << 1
        s.physicsBody!.collisionBitMask = 0

        s.physicsBody!.fieldBitMask = 0x1 << 1

        let direction = MZ.Maths.randomFloat(min: 270 - 30, max: 270 + 30)
        let mv = MZ.Maths.unitVectorFromDegrees(direction)
        let impulse = mv * 0.25

        s.physicsBody!.applyImpulse(impulse.toCGVector())
    }
}
