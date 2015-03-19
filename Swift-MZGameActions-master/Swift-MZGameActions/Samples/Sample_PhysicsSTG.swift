import Foundation
import SpriteKit

@objc public class Sample_PhysicsSTG : NSObject, MZPQueueActionElemnt, SKPhysicsContactDelegate {

    enum Category: UInt32 {
        case Unkonw
        case playerCategoty
        case bulletCategoty

        var collisionBisMask: UInt32 { get { return 1 << self.rawValue } }
    }

    private let attackInterval: Double = 0.3

    public var scene: SKScene!

    public var title: String! = ""

    public var isDone: Bool { get { return false } }

    public func start() {
        scene.physicsWorld.gravity = CGVector.zeroVector
        scene.physicsWorld.contactDelegate = self

        _spritesLayer.zPosition = 1
        _debugDrawsLayer.zPosition = 2

        scene.addChild(_debugDrawsLayer)
        scene.addChild(_spritesLayer)

        _colddownCount = attackInterval

        _setPlayer()
    }

    public func update(currentTime: NSTimeInterval) {
        _gameTime.update(currentTime: currentTime)
        _updateBullets()

        _colddownCount -= _gameTime.deltaTime
        if _colddownCount > 0 { return }

        _colddownCount += attackInterval

        for i in 1...10 { _randomCreateNewBullet() }
    }

    public func didFinishUpdate() {
        _debugDrawsLayer.removeAllChildren()

        _removeInvaliadBullets()
        _remvoeOutOfBoundBullets()
    }

    public func end() {}

    public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchPos = (touches.anyObject() as UITouch).locationInNode(_spritesLayer)

        _beganTouchPosition = touchPos
        _beganPlayerPosition = _player.position
    }

    public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if _beganTouchPosition == nil || _beganPlayerPosition == nil { return }

        let touchPos = (touches.anyObject() as UITouch).locationInNode(_spritesLayer)

        let offset = _beganTouchPosition! - touchPos
        _player.position = _beganPlayerPosition! - offset
    }

    public func didBeginContact(contact: SKPhysicsContact) {
//        var body = contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask ?
//            contact.bodyA : contact.bodyB
//
//        _willBeRemovedBullets.append(body.node!)
    }



    // MARK: Private

    private var _spritesLayer = SKNode()

    private var _debugDrawsLayer = SKNode()

    private var _player: SKSpriteNode!

    private var _colddownCount: Double = 0

    private var _gameTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Time, fps: 30)

    private var _center: CGPoint { get { return CGPoint(size: scene.size / 2) } }

    private var _beganTouchPosition: CGPoint?

    private var _beganPlayerPosition: CGPoint?

    private var _bulletsUpdater = [SKNode]()

    private var _willBeRemovedBullets = [SKNode]()

    private func _setPlayer() {
//        _player = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 40, height: 10))
        _player = SKSpriteNode(texture: SKTexture(imageNamed: "C005_deer_thum"))
        _player.name = "player"
        _player.zPosition = -1
        _spritesLayer.addChild(_player)
        _player.physicsBody = SKPhysicsBody(rectangleOfSize: _player.size)
        _player.physicsBody = SKPhysicsBody(texture: _player.texture!, size: _player.size)
//        _player.physicsBody = SKPhysicsBody(circleOfRadius: _player.size.width / 2)
        _player.physicsBody!.dynamic = false
        _player.physicsBody!.categoryBitMask = Category.playerCategoty.collisionBisMask

        _player.position = _center + CGPoint(x: 0, y: -160)
        _player.scale = 0.25
        _player.rotation = 45

        _player.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.scaleTo(1, duration: 0.5),
                SKAction.scaleTo(0.25, duration: 0.5),
            ])
        ))
    }

    private func _randomCreateNewBullet() {
        let degree = MZ.Maths.randomFloat(min: 0, max: 360.0)
        let impulseDirection = MZ.Maths.randomFloat(min: 0, max: 360)
        let moveVector = MZ.Maths.unitVectorFromDegrees(impulseDirection).toCGVector() * 5
        var bullet = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 12, height: 4))
        bullet.name = "bullet"
        _spritesLayer.addChild(bullet)
        bullet.position = _center

        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.restitution = 1.0
        bullet.physicsBody!.allowsRotation = true
        bullet.physicsBody!.categoryBitMask    = Category.bulletCategoty.collisionBisMask
        bullet.physicsBody!.contactTestBitMask = Category.playerCategoty.collisionBisMask
        bullet.physicsBody!.collisionBitMask   = Category.playerCategoty.collisionBisMask

        bullet.rotation = impulseDirection

        bullet.userData = NSMutableDictionary()
        bullet.userData!["dx"] = moveVector.dx
        bullet.userData!["dy"] = moveVector.dy

        _bulletsUpdater.append(bullet)
    }

    private func _updateBullets() {
        for b in _bulletsUpdater {
            let x = b.userData!["dx"] as CGFloat
            let y = b.userData!["dy"] as CGFloat

            b.position.x += x
            b.position.y += y
        }
    }

    private func _remvoeOutOfBoundBullets() {
        let bound = CGRect(center: _center, size: scene.size * 0.8)

        var removeIndexes = [Int]()

        for (ix, b) in enumerate(_bulletsUpdater) {
            if !CGRectContainsPoint(bound, b.position) {
                b.removeFromParent()
                removeIndexes.append(ix)
            }
        }

        removeIndexes.sort { $1 < $0 }

        for ix in removeIndexes { _bulletsUpdater.removeAtIndex(ix) }
    }

    private func _removeInvaliadBullets() {
        for b in _willBeRemovedBullets {
            if let ix = find(_bulletsUpdater, b) {
                _bulletsUpdater.removeAtIndex(ix)
                b.removeFromParent()
            }
        }

        _willBeRemovedBullets.removeAll(keepCapacity: false)
    }
}