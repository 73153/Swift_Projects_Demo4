// AWT

import Foundation
import SpriteKit

@objc public class ActorWindTunnel : NSObject, MZPQueueActionElemnt, MZPTouchNotifier, SKPhysicsContactDelegate {

    let ENABLE_DEBUG_DRAW = true

    enum ActorCategory: UInt32 {
        case Unkonw

        case Player
        case PlayerBullet

        case Enemy
        case EnemyBullet

        var collisionBisMask: UInt32 { get { return 1 << self.rawValue } }
    }

    public var title: String = "預設的 AWT"

    public var isDone: Bool = false

    public var bulletSize: CGSize = CGSize(width: 10, height: 5)

    public var bulletsBound: CGRect = CGRect.one

    public var playerBound: CGRect = CGRect.one

    public var center: CGPoint { get { return CGPoint(size: scene.size / 2) } }

    public var commonActionTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30.0)

    public var playerActionTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30.0)

    public var enemyActionTime  = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30.0)

    public var scene: SKScene!

    init(scene: SKScene) {
        super.init()

        MZ.GameDebugs.instance.debug = ENABLE_DEBUG_DRAW

        self.scene = scene
        self.scene.physicsWorld.contactDelegate = self

        bulletsBound = CGRect(size: scene.size * 0.9)
        bulletsBound.center = CGPoint(size: scene.size / 2)

        playerBound = CGRect(size: scene.size * 0.9)
        playerBound.center = CGPoint(size: scene.size / 2)

        _setLayers()
        _setUpdaters()
    }

    public func addTouchResponder(touchResponder: AnyObject) {
        _touchResponders.append(touchResponder as MZPTouchResponder)
    }

    public func removeTouchResponder(touchResponder: AnyObject) {
        var index: Int? = nil
        for i in 0..<_touchResponders.count {
            if _touchResponders[i] === touchResponder { index = i; break }
        }

        if index != nil { _touchResponders.removeAtIndex(index!) }
    }

    public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        _touchResponders.map { (t) in t.touchesBegan(touches) }
    }

    public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        _touchResponders.map { (t) in t.touchesMoved(touches) }
    }

    public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        _touchResponders.map { (t) in t.touchesEnded(touches) }
    }

    public func positionWithTouch(touch: UITouch) -> CGPoint {
        return touch.locationInNode(_playerLayer)
    }

    public func start() {
        newPlayer()
        newEnemy()

        _playersUpdater.start()
        _enemiesUpdater.start()
        _playerBulletsUpdater.start()
        _enemyBulletsUpdater.start()
    }

    public func update(currentTime: NSTimeInterval) {
        _updateActionTimes(currentTime)
        _updateUpdaters()
        _updateUpdatersCollision()
    }

    public func didFinishUpdate() {
        _enemiesUpdater.removeInactiveActions()
        _playerBulletsUpdater.removeInactiveActions()
        _enemyBulletsUpdater.removeInactiveActions()

        _debugDraws()
    }

    public func end() {
    }

    public func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask { return }

        let mzPhyBodyName = MZ.PhysicsBody.actionName()

        if contact.bodyA.node != nil && contact.bodyA.node!.mzUserData[mzPhyBodyName] != nil {
            let pb = contact.bodyA.node!.mzUserData[mzPhyBodyName]! as MZ.PhysicsBody
            pb.bodiesContactAction?(selfBody: contact.bodyA, otherBody: contact.bodyB)
        }

        if contact.bodyB.node != nil && contact.bodyB.node!.mzUserData[mzPhyBodyName] != nil {
            let pb = contact.bodyB.node!.mzUserData[mzPhyBodyName]! as MZ.PhysicsBody
            pb.bodiesContactAction?(selfBody: contact.bodyB, otherBody: contact.bodyA)
        }
    }

    public func newEnemyBullet() -> MZ.Actor {
        var bullet = _enemyBulletsUpdater.addAction(MZ.Actor())

        var bodySprite = SKSpriteNode(color: SKColor.yellowColor(), size: self.bulletSize)
        _enemyBulletsLayer.addChild(bodySprite)

        bullet.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: bodySprite, name: "body")
            return // HACK: fix :D
        }

        var boundTest = bullet.addActionWithName("bound", action: MZ.BoundTest(tester: bullet, bound: bulletsBound))

        bullet.addActionWithName("faceTo", action: MZ.Action()) {
            [weak bullet] (a) in
            a.updateAction = {
                (_) in
                if bullet?.actionsWithClass(MZ.Moves.VelocityDirection.self) == nil { return }

                var moves = bullet!.actionsWithClass(MZ.Moves.VelocityDirection.self)
                if moves.count == 0 || moves.count > 1 { return }

                bullet!.rotation = (moves.first? as MZ.Moves.Base).currentDirection
            }
        }

        bullet.addActionWithName("main-collider",
            action: MZ.SpriteCircleCollider(sprite: bodySprite, collisionScale: 0.5)
        )

        bullet.addActiveCondition({ [weak boundTest] in boundTest!.isInBound })
        
        return bullet
    }

    public func newPlayerBullet() -> MZ.Actor {
        var bullet = _playerBulletsUpdater.addAction(MZ.Actor())

        var bodySprite = SKSpriteNode(color: SKColor.purpleColor(), size: self.bulletSize)
        _playerBulletsLayer.addChild(bodySprite)

        bullet.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: bodySprite, name: "body")
            return
        }

        var boundTest = bullet.addActionWithName("bound", action: MZ.BoundTest(tester: bullet, bound: bulletsBound))

        bullet.addActionWithName("faceTo", action: MZ.Action()) {
            [weak bullet] (a) in
            a.updateAction = {
                (_) in
                if bullet?.actionsWithClass(MZ.Moves.VelocityDirection.self) == nil { return }

                var moves = bullet!.actionsWithClass(MZ.Moves.VelocityDirection.self)
                if moves.count == 0 || moves.count > 1 { return }

                bullet!.rotation = (moves.first? as MZ.Moves.Base).currentDirection
            }
        }

        bullet.addActionWithName("physical-body", action: MZ.PhysicsBody(node: bodySprite, circleOfRadius: 10)) {
            [weak self, weak bullet] (pb) in
            self!._setPhysicsBody(pb.physicsBody,
                categoryBitMask: ActorCategory.PlayerBullet.collisionBisMask,
                contactTestBitMask: ActorCategory.Enemy.collisionBisMask
            )
        }

        bullet.addActiveCondition({ [weak boundTest] in boundTest!.isInBound })

        return bullet
    }

    public func newEnemy() -> MZ.Actor {
        var enemy = _enemiesUpdater.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.brownColor(), size: CGSize(width: 32, height: 16))
        _enemiesLayer.addChild(sprite)

        enemy.addAction(MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: sprite, name: "body")
            return
        }

        enemy.addActionWithName("attack-odd", action: MZ.Attacks.OddNWayToDirection(attacker: sprite)) {
            [weak self, weak enemy] (attack) in
            attack.targetDirectionFunc = { return enemy!.rotation }
            attack.numberOfWays = 3
            attack.bulletGenFunc = { return self?.newEnemyBullet() }
            attack.bulletVelocity = 200
            attack.colddown = 0.25
            attack.interval = 45
            attack.offset = CGPoint(x: -16, y: -8)
        }

        enemy.addActionWithName("attack-even", action: MZ.Attacks.EvenNWayToDirection(attacker: sprite)) {
            [weak self, weak enemy] (attack) in
            attack.targetDirectionFunc = { return enemy!.rotation }
            attack.numberOfWays = 2
            attack.bulletGenFunc = { return self?.newEnemyBullet() }
            attack.bulletVelocity = 100
            attack.colddown = 0.25
            attack.interval = 45
            attack.offset = CGPoint(x: -16, y: 8)
        }

        enemy.addAction(MZ.Action()) {
            [weak enemy] (a) in
            a.updateAction = { (_a) in enemy!.rotation += 50 * _a.deltaTime }
        }

        enemy.addActionWithName("physical-body", action: MZ.PhysicsBody(node: sprite, circleOfRadius: 10)) {
            [weak self] (physicsBody) in
            self!._setPhysicsBody(physicsBody.physicsBody,
                categoryBitMask: ActorCategory.Enemy.collisionBisMask,
                contactTestBitMask: ActorCategory.Player.collisionBisMask
            )
        }

        enemy.position = center
        enemy.rotation = -90
        
        return enemy
    }

    public func newPlayer() -> MZ.Actor {
        var player = _playersUpdater.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 16, height: 16))
        self._playerLayer.addChild(sprite)

        player.addActionWithName("nodes", action: MZ.Nodes()) {
            (nodes) in
            nodes.addNewNodeInfo(node: sprite, name: "body")
            return
        }

        player.addActionWithName("physical-body", action: MZ.PhysicsBody(node: sprite, circleOfRadius: 10)) {
            [weak self] (physicsBody) in
            self!._setPhysicsBody(physicsBody.physicsBody,
                categoryBitMask: ActorCategory.Player.collisionBisMask,
                contactTestBitMask: ActorCategory.Enemy.collisionBisMask
            )
        }

        player.addActionWithName("touch-move",
            action: MZ.TouchRelativeMove(mover: player, touchNotifier: self, bound: playerBound)
        )

        player.addActionWithName("attack", action: MZ.Attacks.OddNWayToDirection(attacker: sprite)) {
            [weak self, weak player] (attack) in
            attack.targetDirection = 90
            attack.numberOfWays = 3
            attack.bulletGenFunc = { return self?.newPlayerBullet() }
            attack.bulletVelocity = 400
            attack.colddown = 0.25
            attack.interval = 30
        }

        player.position = CGPoint(x: scene.size.width / 2, y: 150)

        return player
    }



    private var _enemiesLayer     = SKNode()

    private var _playerBulletsLayer = SKNode()

    private var _enemyBulletsLayer  = SKNode()

    private var _playerLayer        = SKNode()

    private var _debugLayer         = SKNode()

    private var _enemiesUpdater        = MZ.ActionsGroup()

    private var  _playerBulletsUpdater = MZ.ActionsGroup()

    private var _enemyBulletsUpdater   = MZ.ActionsGroup()

    private var _playersUpdater        = MZ.ActionsGroup()

    private var _touchResponders = [MZPTouchResponder]()

    deinit {
        _playersUpdater.removeAllActions()
        _enemiesUpdater.removeAllActions()
        _playerBulletsUpdater.removeAllActions()
        _enemyBulletsUpdater.removeAllActions()

        _enemiesLayer.removeFromParent()
        _playerBulletsLayer.removeFromParent()
        _enemyBulletsLayer.removeFromParent()
        _playerLayer.removeFromParent()
    }

    private func _setLayers() {
        scene.addChild(_playerLayer)
        scene.addChild(_enemiesLayer)
        scene.addChild(_playerBulletsLayer)
        scene.addChild(_enemyBulletsLayer)
        scene.addChild(_debugLayer)
    }

    private func _setUpdaters() {
        _playersUpdater.actionTime       = playerActionTime
        _playerBulletsUpdater.actionTime = playerActionTime

        _enemiesUpdater.actionTime      = enemyActionTime
        _enemyBulletsUpdater.actionTime = enemyActionTime
    }

    private func _updateActionTimes(currentTime: NSTimeInterval) {
        commonActionTime.update(currentTime: currentTime)
        playerActionTime.update(currentTime: currentTime)
        enemyActionTime.update(currentTime: currentTime)
    }

    private func _updateUpdaters() {
        _playersUpdater.update()
        _enemiesUpdater.update()

        _playerBulletsUpdater.update()
        _enemyBulletsUpdater.update()
    }

    private func _updateUpdatersCollision() {
        for eb in _enemyBulletsUpdater.updatingActions {

            var ebColliders =
                (eb as MZ.Actor).actionsWithClass(MZ.SpriteCircleCollider.self) as [MZ.SpriteCircleCollider]

            for p in _playersUpdater.updatingActions {
                var pColliders =
                    (p as MZ.Actor).actionsWithClass(MZ.SpriteCircleCollider.self) as [MZ.SpriteCircleCollider]

                if _testColliders(colliders1: ebColliders, colliders2: pColliders) {
                    _enemyBulletsUpdater.removeActionLate(eb)
               }
            }
        }
    }

    private func _testColliders(
        #colliders1: [MZ.SpriteCircleCollider],
        colliders2: [MZ.SpriteCircleCollider])
    -> Bool {
        for c1 in colliders1 {
            for c2 in colliders2 {
                if c1.isCollidesWithAnother(c2) {
                     return true
                }
            }
        }

        return false
    }

    private func _setPhysicsBody(physicsBody: SKPhysicsBody, categoryBitMask: UInt32, contactTestBitMask: UInt32) {
        physicsBody.affectedByGravity  = false
        physicsBody.categoryBitMask    = categoryBitMask
        physicsBody.contactTestBitMask = contactTestBitMask
        physicsBody.collisionBitMask   = 0
    }

    // MARK: Collisitions Handler

    private func _collisionHandle(#playerBullet: MZ.Actor, enemy: MZ.Actor) {
        playerBullet.setInactive()
    }

    private func _collisionHandle(#enemyBullet: MZ.Actor, player: MZ.Actor) {
        enemyBullet.setInactive()
    }

    private func _debugDraws() {
        if !ENABLE_DEBUG_DRAW { return }

        _debugLayer.removeAllChildren()

        for node in _playerLayer.children {
            MZ.GameDebugs.drawColliderWithNode(node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
            )
        }

        for node in _enemiesLayer.children {
            MZ.GameDebugs.drawColliderWithNode(node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
            )
        }

        for node in _playerBulletsLayer.children {
            MZ.GameDebugs.drawColliderWithNode(node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.3)
            )
        }

        for node in _enemyBulletsLayer.children {
            MZ.GameDebugs.drawColliderWithNode(node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.3)
            )
        }
    }
}
