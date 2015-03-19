import Foundation
import SpriteKit

@objc public class TestMZActionWithSKPhysics :
    NSObject, MZPQueueActionElemnt, MZPTouchNotifier, SKPhysicsContactDelegate {

    let ENABLE_PHYSICS = true

    let ENABLE_CREATE_ENEMIES = false
    let ENABLE_ENEMY_ATTACK   = true
    let ENABLE_ENEMY_MOVE     = false
    let ENABLE_DEBUG_DRAW     = false

    let ENEMY_SPAWN_INTERVAL = 0.5

    let ENEMY_HEALTH_POINT: Int = 100

    enum ActorCategoty: UInt32 {
        case Player
        case Enemy
        case PlayerBullet
        case EnemyBullet

        static func fromBisMask(bitMask: UInt32) -> ActorCategoty? { return ActorCategoty(rawValue: bitMask) }

        var bitMask: UInt32 { get { return 1 << self.rawValue } }
    }

    public var scene: SKScene!

    public var title: String! = ""

    public var isDone: Bool { get { return false } }

    public func start() {
        MZ.GameDebugs.instance.debug = ENABLE_DEBUG_DRAW

        _bound = CGRect(center: CGPoint(size: scene.size / 2), size: scene.size * 0.9)

        _setPhysicsWorld()
        _setLayers()
        _setUpdaters()
        _setPlayer()
        _setGUIs()

        _newEnemyAt(_center)
    }

    public func update(currentTime: NSTimeInterval) {
        _gameTime.update(currentTime: currentTime)
        _enemyTime.update(currentTime: currentTime)
        _updateAllUpdaters()
        _updateToCreateEnemy()
    }

    public func didFinishUpdate() {
        _debugLayer.removeAllChildren()

        for node in _enemiesLayer.children {
            MZ.GameDebugs.drawColliderWithNode(
                node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 0.0, green: 1.0, blue: 0, alpha: 0.3)
            )
        }

        for node in _playerBulletsLayer.children {
            MZ.GameDebugs.drawColliderWithNode(
                node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
            )
        }

        for node in _enemyBulletsLayer.children {
            MZ.GameDebugs.drawColliderWithNode(
                node as SKNode,
                parent: _debugLayer,
                color: SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.3)
            )
        }

        _playersUpdater.removeInactiveActions()
        _playerBulletsUpdater.removeInactiveActions()
        _enemiesUpdater.removeInactiveActions()
        _enemyBulletsUpdater.removeInactiveActions()
    }

    public func end() {
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
        if touches.count > 1 {
            _enemyTime.timeScale = 0.1
        } else {
            var player = _playersUpdater.updatingActions.first! as MZ.Actor
            player.actionWithName("attack")!.enable = true
            _touchResponders.map { (t) in t.touchesBegan(touches) }
        }
    }

    public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if touches.count > 1 { return }
        _touchResponders.map { (t) in t.touchesMoved(touches) }
    }

    public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        _enemyTime.timeScale = 1

        var player = _playersUpdater.updatingActions.first! as MZ.Actor
        player.actionWithName("attack")!.enable = false
        _touchResponders.map { (t) in t.touchesEnded(touches) }
    }

    public func positionWithTouch(touch: UITouch) -> CGPoint {
        return touch.locationInNode(_playersLayer)
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



    // MARK: Private

    private var _center: CGPoint { get { return CGPoint(size: scene.size / 2) } }

    private var _bound: CGRect!

    private var _gameTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30)
    private var _enemyTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30)

    private var _playersUpdater       = MZ.ActionsGroup()
    private var _enemiesUpdater       = MZ.ActionsGroup()
    private var _playerBulletsUpdater = MZ.ActionsGroup()
    private var _enemyBulletsUpdater  = MZ.ActionsGroup()

    private var _playersLayer       = SKNode()
    private var _playerBulletsLayer = SKNode()
    private var _enemiesLayer      = MZ.SpritesLayer(altas: SKTextureAtlas(named: "enemies"), numberOfSprites: 50)
    private var _enemyBulletsLayer = MZ.SpritesLayer(
        altas: SKTextureAtlas(named: "enemy_bullets"),
        numberOfSprites: 200
    )

    private var _debugLayer = SKNode()
    private var _guiLayer   = SKNode()

    private var _touchResponders = [MZPTouchResponder]()

    private var _createEnemyCount: MZFloat = 0

    deinit {
        _touchResponders.removeAll(keepCapacity: false)

        _playersUpdater.removeAllActions()
        _enemiesUpdater.removeAllActions()
        _playerBulletsUpdater.removeAllActions()
        _enemyBulletsUpdater.removeAllActions()

        _playersLayer.removeFromParent()
        _playerBulletsLayer.removeFromParent()
        _enemiesLayer.removeFromParent()
        _enemyBulletsLayer.removeFromParent()
        _debugLayer.removeFromParent()
    }

    private func _setPhysicsWorld() {
        scene.physicsWorld.contactDelegate = self
    }

    private func _setLayers() {
        _playersLayer.zPosition       = 10
        _enemiesLayer.zPosition       = 20
        _playerBulletsLayer.zPosition = 30
        _enemyBulletsLayer.zPosition  = 40
        _debugLayer.zPosition         = 50
        _guiLayer.zPosition           = 60

        _setEnemyAnimatons()

        scene.addChild(_playersLayer)
        scene.addChild(_enemiesLayer)
        scene.addChild(_playerBulletsLayer)
        scene.addChild(_enemyBulletsLayer)
        scene.addChild(_debugLayer)
        scene.addChild(_guiLayer)
    }

    func _setEnemyAnimatons() {
        _enemiesLayer.addAnimation(
            name: "bow",
            textureNames: [
                "Bow_normal0001",
                "Bow_normal0002",
                "Bow_normal0003",
                "Bow_normal0004",
                "Bow_normal0005",
                "Bow_normal0006",
                "Bow_normal0007",
                "Bow_normal0008",
                "Bow_normal0009",
                "Bow_normal0010",
                "Bow_normal0011",
                "Bow_normal0012",
            ],
            oneLoopTime: 0.5
        )

        _enemiesLayer.addAnimation(
            name: "ship",
            textureNames: [
                "ship_0001",
                "ship_0002",
                "ship_0003",
                "ship_0004",
                "ship_0005",
                "ship_0006",
                "ship_0007",
                "ship_0008",
                "ship_0009",
                "ship_0010",
            ],
            oneLoopTime: 0.5
        )

        _enemiesLayer.addAnimation(
            name: "monster_blue",
            textureNames: [
                "monster_blue_0001",
                "monster_blue_0002",
                "monster_blue_0003",
                "monster_blue_0004",
            ],
            oneLoopTime: 0.5
        )

        _enemiesLayer.addAnimation(
            name: "monster_red",
            textureNames: [
                "monster_red_0001",
                "monster_red_0002",
                "monster_red_0003",
                "monster_red_0004",
            ],
            oneLoopTime: 0.5
        )

        _enemiesLayer.addAnimation(
            name: "monster_green",
            textureNames: [
                "monster_green_0001",
                "monster_green_0002",
                "monster_green_0003",
                "monster_green_0004",
            ],
            oneLoopTime: 0.5
        )
    }

    private func _setUpdaters() {
        _playersUpdater.actionTime       = _gameTime
        _playerBulletsUpdater.actionTime = _gameTime
        _enemiesUpdater.actionTime       = _enemyTime
        _enemyBulletsUpdater.actionTime  = _enemyTime
    }

    private func _setPlayer() {
        var actor = _playersUpdater.addAction(MZ.Actor())

        var body = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 12, height: 12))
        _playersLayer.addChild(body)

        actor.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: body, name: "body")
            return
        }

        if ENABLE_PHYSICS {
            actor.addActionWithName("physics-body",
                action: MZ.PhysicsBody(node: body, circleOfRadius: body.size.width / 2)
            ) {
                [weak self] (pb) in
                self!._setPhysicsBody(pb.physicsBody,
                    categoryBitMask: ActorCategoty.Player.bitMask,
                    contactTestBitMask: ActorCategoty.Enemy.bitMask + ActorCategoty.EnemyBullet.bitMask
                )
            }
        }

//        actor.addActionWithName("attack", MZ.Attacks.OddNWayToDirection())

        let gameBound = CGRect(center: _center, size: scene.size)
        actor.addActionWithName("touch-relative-move", action: MZ.TouchRelativeMove(
            mover: actor,
            touchNotifier: self,
            bound: gameBound
        ))

        actor.addActionWithName("teleport-relative-move", action: MZ.TouchTeleportMove(
            mover: actor,
            touchNotifier: self,
            bound: gameBound
        ))

        actor.addActionWithName("attack", action: MZ.Attacks.OddNWayToDirection(attacker: actor)) {
            [weak self] (a) in
            a.bulletGenFunc = { return self?._newPlayerBullet() }
            a.bulletVelocity = 600
            a.numberOfWays = 3
            a.interval = 15
            a.colddown = 0.2
            a.targetDirection = 90
        }.enable = false

        actor.position = _center
        actor.position.y -= 200
    }

    private func _setGUIs() {
        var gotoGameScene = SKLabelNode(text: "Back to Hell")
        _guiLayer.addChild(gotoGameScene)
        gotoGameScene.position = CGPoint(x: _center.x, y: scene.size.height - 40)

        gotoGameScene.addTouch(type: MZ.TouchType.Began, touchAction: {
            [weak self] (_, _, _) in
            self?.scene.view?.presentScene(GameScene())
            return
        })
    }

    private func _newEnemyAt(position: CGPoint) {
        var actor = _enemiesUpdater.addAction(MZ.Actor())

        var body = _enemiesLayer.spriteWithForeverAnimation(animationName: "bow")

        actor.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: body, name: "body")
            return
        }

        var health = actor.addActionWithName("health", action: MZ.Health())
        health.healthPoint = ENEMY_HEALTH_POINT

        if ENABLE_PHYSICS {
            actor.addActionWithName("physics-body",
                action: MZ.PhysicsBody(node: body, rectangleOfSize: body.size)
            ) {
                [weak self, weak actor, weak health] (pb) in
                self!._setPhysicsBody(pb.physicsBody,
                    categoryBitMask: ActorCategoty.Enemy.bitMask,
                    contactTestBitMask: ActorCategoty.Player.bitMask
                )
                pb.bodiesContactAction = { (_, _) in health?.healthPoint -= 1; return }

                return
            }
        }

        let playerNode = _playersLayer.children.first! as SKNode

        let constrain = SKConstraint.orientToNode(
            playerNode,
            offset: SKRange()
        )

        body.constraints = [constrain]

        if ENABLE_ENEMY_ATTACK {
            actor.addActionWithName("attack", action: MZ.Attacks.OddNWayToDirection(attacker: actor)) {
                [weak self] (a) in
                a.bulletGenFunc = { return self?._newEnemyBullet() }
                a.bulletScale = 0.15
                a.bulletVelocity = 150
                a.numberOfWays = 3
                a.interval = 30
                a.colddown = 0.5
                a.targetDirection = 270
            }
        }

        if ENABLE_ENEMY_MOVE {
            actor.addActionWithName("move", action: MZ.Moves.VelocityDirection(mover: actor)) {
                (m) in
                m.direction = 270
                m.velocity = 100
            }
        }

        var boundTest = actor.addActionWithName("bound-test",
            action: MZ.BoundTest(tester: actor, testerSize: body.size, bound: _bound)
        )

        actor.addActiveCondition({ [weak boundTest] in boundTest!.isInBound })
        actor.addActiveCondition({ [weak health] in health!.healthPoint > 0 })

        actor.rotation = 270
        actor.position = position
        actor.scale = 0.5
    }

    private func _newPlayerBullet() -> MZ.Actor {
        let bulletSize = CGSize(width: 4, height: 2) * 1

        var bullet = _playerBulletsUpdater.addAction(MZ.Actor())

        var body = SKSpriteNode(color: SKColor.blueColor(), size: bulletSize)
        _playerBulletsLayer.addChild(body)

        bullet.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: body, name: "body")
            return
        }

        var boundTest = bullet.addActionWithName("bound-test",
            action: MZ.BoundTest(tester: bullet, testerSize: bulletSize, bound: _bound)
        )

        if ENABLE_PHYSICS {
            bullet.addActionWithName("physics-body",
                action: MZ.PhysicsBody(node: body, circleOfRadius: body.size.width)
            ) {
                [weak self, weak bullet] (pb) in
                self!._setPhysicsBody(pb.physicsBody,
                    categoryBitMask: ActorCategoty.PlayerBullet.bitMask,
                    contactTestBitMask: ActorCategoty.Enemy.bitMask
                )

                pb.bodiesContactAction = { (_, _) in bullet?.setInactive(); return }
            }
        }

        bullet.addActiveCondition({ [weak boundTest] in boundTest!.isInBound })

        bullet.scale = 3

        return bullet
    }

    private func _newEnemyBullet() -> MZ.Actor {
        let bulletSize = CGSize(width: 4, height: 2) * 4

        var bullet = _enemyBulletsUpdater.addAction(MZ.Actor())

        var body = _enemyBulletsLayer.spriteWithTexture(textureName: "shell_tank")

        bullet.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            nodes.addNewNodeInfo(node: body, name: "body"); return
        }

        if ENABLE_PHYSICS {
            bullet.addActionWithName("physics-body",
                action: MZ.PhysicsBody(node: body, circleOfRadius: body.size.width / 2)
            ) {
                [weak self, weak bullet] (pb) in
                self!._setPhysicsBody(pb.physicsBody,
                    categoryBitMask: ActorCategoty.EnemyBullet.bitMask,
                    contactTestBitMask: ActorCategoty.Player.bitMask
                )
                pb.bodiesContactAction = { (_, _) in bullet?.setInactive(); return }
            }
        }

        var boundTest = bullet.addActionWithName("bound-test",
            action: MZ.BoundTest(tester: bullet, testerSize: bulletSize, bound: _bound)
        )

        bullet.addActiveCondition({ [weak boundTest] in boundTest!.isInBound })

        return bullet
    }

    private func _setPhysicsBody(physicsBody: SKPhysicsBody, categoryBitMask: UInt32, contactTestBitMask: UInt32) {
        physicsBody.affectedByGravity  = false
        physicsBody.categoryBitMask    = categoryBitMask
        physicsBody.contactTestBitMask = contactTestBitMask
        physicsBody.collisionBitMask   = 0
    }

    private func _updateAllUpdaters() {
        _playersUpdater.update()
        _enemiesUpdater.update()
        _playerBulletsUpdater.update()
        _enemyBulletsUpdater.update()
    }

    private func _updateToCreateEnemy() {
        if !ENABLE_CREATE_ENEMIES { return }

        let spawnY = scene.size.height - 20
        let spawnPosXRange = 20.0...(scene.size.width.toMZFloat() - 20.0)

        _createEnemyCount -= _gameTime.deltaTime

        if _createEnemyCount > 0 { return }
        _createEnemyCount += ENEMY_SPAWN_INTERVAL

        let spawnX = MZ.Maths.randomFloat(
            min: spawnPosXRange.start,
            max: spawnPosXRange.end
        ).toCGFloat()

        _newEnemyAt(CGPoint(x: spawnX, y: spawnY))
    }
}