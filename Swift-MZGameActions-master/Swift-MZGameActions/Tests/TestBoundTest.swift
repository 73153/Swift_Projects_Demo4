import Foundation
import SpriteKit

@objc public class TestBoundTest : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 BoundTest"

    public var description: String! = ""

    public var isDone: Bool { get { return _passedTime >= _testDuration } }

    init() {}

    public func start() {
        _passedTime = 0
        _testDuration = 10

        _spawnTimeCount = _SPAWN_INTERVAL

        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _bound = CGRect(origin: CGPoint.zero, size: scene.size * 0.8)
        _bound.center = CGPoint(size: scene.size / 2)

        _setBoundDisplay()
        _createSpriteFromCenterToRandomDirection()

        _updaters.start()
    }

    public func update(currentTime: NSTimeInterval) {
        _updaters.update()

        var dt = _deltaTimeWithCurrent(currentTime)

        _passedTime += dt
        _countDownToSpawnNewSpriteWithDeltaTime(dt)
    }

    public func end() {
        MZ.assert(_spawnTestCounter == 0, "出生和死亡的數目不符合, counter = %d", _spawnTestCounter)
        MZ.assert(_updaters.count == 0, "_updaters should be ZERO, but %d", _updaters.count)
    }

    // MARK: Private

    let _SPAWN_INTERVAL: NSTimeInterval = 0.05

    let _MAX_SPAWN_TIMES: Int = 50

    var _testLayer : SKNode!

    var _bound : CGRect!

    var _spawnTimeCount: NSTimeInterval = 0

    var _spawnCount: Int = 0

    var _preTime: NSTimeInterval = 0

    var _passedTime: NSTimeInterval = 0

    var _testDuration: NSTimeInterval = 9999

    var _updaters = MZ.ActionsGroup()

    // 測試變數

    // 當 spawn 發生時 +1, 死亡 -1, 所以最後需驗證是否為 0
    var _spawnTestCounter: Int = 0

    deinit {
    }

    func _setBoundDisplay() {
        var boundSprite = SKShapeNode(rect: _bound)
        _testLayer.addChild(boundSprite)
        boundSprite.fillColor = SKColor(red: 1, green: 0, blue: 0, alpha: 0.2)
    }

    func _deltaTimeWithCurrent(currentTime: NSTimeInterval) -> NSTimeInterval {
        if _preTime == 0 {
            _preTime = currentTime
            return 0
        }

        return (currentTime - _preTime) * 0.01 // why????
    }

    func _countDownToSpawnNewSpriteWithDeltaTime(deltaTime: NSTimeInterval) {
        if _spawnCount >= _MAX_SPAWN_TIMES { return }

        _spawnTimeCount -= deltaTime

        if _spawnTimeCount > 0 { return }

        _createSpriteFromCenterToRandomDirection()
        _spawnTimeCount += _SPAWN_INTERVAL
        _spawnCount++
    }

    func _createSpriteFromCenterToRandomDirection() {
        var moveActor = MZ.Actor(name: "I can move")

        moveActor.startAction  = { [weak self] (_) in self!._spawnTestCounter = self!._spawnTestCounter + 1 }
        moveActor.deinitAction = { [weak self] (_) in self!._spawnTestCounter = self!._spawnTestCounter - 1 }

        let moveDeg    = MZ.Maths.randomInt(0...360)
        let moveVector = MZ.Maths.unitVectorFromDegrees(MZFloat(moveDeg))
        let size       = CGSize(width: 20, height: 20)
        let velocity   = 100.0

        moveActor.addActionWithName("move", action: MZ.Action()) {
            [weak moveActor] (a) in
            let movement = moveVector * CGFloat(velocity * a.deltaTime)

            a.updateAction = { (_) in moveActor!.position += movement }
        }

        moveActor.addActionWithName("nodes", action: MZ.Nodes()) {
            [weak self] (nodes) in
            let color = SKColor(
                red:    CGFloat(MZ.Maths.randomFloat()),
                green:  CGFloat(MZ.Maths.randomFloat()),
                blue:   CGFloat(MZ.Maths.randomFloat()),
                alpha:  0.5
            )

            var sprite = SKSpriteNode(color: color, size: size)
            self!._testLayer.addChild(sprite)

            nodes.addNewNodeInfo(node: sprite, name: "sprite")
        }

        moveActor.addActionWithName(
            "bound-test",
            action: MZ.BoundTest(tester: moveActor, testerSize: size, bound: _bound, outOfBoundAction: {
                [weak self, weak moveActor] (_, _) in

                var actorRect = CGRect(center: moveActor!.position, size: size)

                MZ.assert(self!._bound.contains(actorRect) == false, "remvoe actor should not be in bound")

                self!._updaters.removeAction(moveActor!)
            })
        )

        moveActor.position = CGPoint(size: scene.size / 2)

        _updaters.addAction(moveActor)
    }
}