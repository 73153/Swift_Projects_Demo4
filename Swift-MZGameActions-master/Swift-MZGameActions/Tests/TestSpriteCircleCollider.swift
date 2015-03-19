import Foundation
import SpriteKit

public class TestSpriteCircleCollider : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 SpriteCircleCollider"

    public var description: String! = ""

    public var isDone: Bool { get { return _testStateSettingActions.count == 0 } }

    init() {}

    public func start() {
        _testDebugDrawsLayer.zPosition = 2
        _testSpritesLayer.zPosition = 1

        scene.addChild(_testDebugDrawsLayer)
        scene.addChild(_testSpritesLayer)

        _actor1 = _newActorWithName("actor1")
        _actor2 = _newActorWithName("actor2")

        _testStateSettingActions.append(_setTestState1)
        _testStateSettingActions.append(_setTestState2)
        _testStateSettingActions.append(_setTestState3)
        _testStateSettingActions.append(_setTestState4)

        _applyTestStateSettingAction()
    }

    public func update(currentTime: NSTimeInterval) {
        _updaters.update()

        var a1Colliders = _actor1.actionsWithClass(MZ.SpriteCircleCollider.self)
        var a2Colliders = _actor2.actionsWithClass(MZ.SpriteCircleCollider.self)

        for a1Collider in a1Colliders {
            for a2Collider in a2Colliders {
                let a1c = a1Collider as MZ.SpriteCircleCollider
                let a2c = a2Collider as MZ.SpriteCircleCollider

                if a1c.isCollidesWithAnother(a2c) {
                    // TODO: need test !!!
                    _removeColliderAndMoveFromAllActors()
                    _applyTestStateSettingAction()
                }
            }
        }
    }

    public func didFinishUpdate() {
        let a1ColliderColor = SKColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        let a2ColliderColor = SKColor(red: 0, green: 1, blue: 0, alpha: 0.5)

        _testDebugDrawsLayer.removeAllChildren()

        MZ.GameDebugs.drawCircleColliderWithActor(_actor1, toParent: _testDebugDrawsLayer, color: a1ColliderColor)
        MZ.GameDebugs.drawCircleColliderWithActor(_actor2, toParent: _testDebugDrawsLayer, color: a2ColliderColor)
    }

    public func end() {
        _testSpritesLayer.removeFromParent()
        _testDebugDrawsLayer.removeFromParent()
    }



    // MARK: Private

    private var _updaters = MZ.ActionsGroup()

    private var _testSpritesLayer = SKNode()

    private var _testDebugDrawsLayer = SKNode()

    private var _actor1: MZ.Actor!

    private var _actor2: MZ.Actor!

    private var _testStateSettingActions = Array<(()->())>()

    private var _currentTestingCount = 0

    private func _newActorWithName(name: String) -> MZ.Actor {
        var actor = MZ.Actor(name: name)

        var s = SKSpriteNode(imageNamed: "bosslogo-sheet0")
        _testSpritesLayer.addChild(s)

        var nodes = MZ.Nodes(name: "nodes")
        nodes.addNewNodeInfo(node: s, name: "sprite")

        actor.addAction(nodes)

        _updaters.addAction(actor)

        return actor
    }

    private func _applyTestStateSettingAction() {
        if _testStateSettingActions.count == 0 { return }

        if _currentTestingCount >= 3 {
            _testStateSettingActions.removeRange(Range(start: 0, end: 1))
            _currentTestingCount = 0
        }

        _testStateSettingActions.first?()
        _currentTestingCount++
    }

    private func _removeColliderAndMoveFromAllActors() {
        let removeActionNames = ["collider", "move", "rotation"]

        for name in removeActionNames {
            _actor1.removeActionWithName(name)
            _actor2.removeActionWithName(name)
        }

        _actor1.scale = 1
        _actor2.scale = 1
    }

    private func _setTestState1() {
        println("\t--> 測試基本碰撞")

        let center = CGPoint(size: scene.size / 2)

        let actor1Pos = [
            center - CGPoint(x: 15, y: 200),
            center - CGPoint(x: 200, y: 0),
            center - CGPoint(x: 100, y: 100)
        ]
        let actor1MoveVectors = [
            CGPoint(x: 0, y: 5),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 2, y: 2)
        ]

        let actor2Pos = [
            center + CGPoint(x: 15, y: 200),
            center + CGPoint(x: 200, y: 0),
            center + CGPoint(x: 100, y: 100)
        ]
        let actor2MoveVectors = [
            CGPoint(x: 0, y: -5),
            CGPoint(x: -5, y: 0),
            CGPoint(x: -2, y: -2)
        ]

        func addColliderToActor(actor: MZ.Actor) {
            let nodes = actor.actionWithName("nodes") as MZ.Nodes
            let sprite = nodes.nodeInfoWithName("sprite")!.node as SKSpriteNode

            actor.addActionWithName(
                "collider",
                action: MZ.SpriteCircleCollider(sprite: sprite, offset: CGPoint.zero, collisionScale: 0.5)
            )
        }

        func addMoveVectorToActor(actor: MZ.Actor, move: CGPoint) {
            actor.addActionWithName("move", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.position += move }
            }
        }

        addColliderToActor(_actor1)
        addColliderToActor(_actor2)

        addMoveVectorToActor(_actor1, actor1MoveVectors[_currentTestingCount])
        addMoveVectorToActor(_actor2, actor2MoveVectors[_currentTestingCount])

        _actor1.position = actor1Pos[_currentTestingCount]
        _actor2.position = actor2Pos[_currentTestingCount]
    }

    private func _setTestState2() {
        println("\t--> 測試變動 scale 碰撞")

        let center = CGPoint(size: scene.size / 2)

        let actor1Pos = [
            center - CGPoint(x: 15, y: 200),
            center - CGPoint(x: 200, y: 0),
            center - CGPoint(x: 100, y: 100),
        ]
        let actor1MoveVectors = [
            CGPoint(x: 0, y: 5),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 2, y: 2)
        ]

        let actor2Pos = [
            center + CGPoint(x: 15, y: 200),
            center + CGPoint(x: 200, y: 0),
            center + CGPoint(x: 100, y: 100)
        ]
        let actor2MoveVectors = [
            CGPoint(x: 0, y: -5),
            CGPoint(x: -5, y: 0),
            CGPoint(x: -2, y: -2)
        ]

        func addColliderToActor(actor: MZ.Actor) {
            let nodes = actor.actionWithName("nodes") as MZ.Nodes
            let sprite = nodes.nodeInfoWithName("sprite")!.node as SKSpriteNode

            actor.addActionWithName(
                "collider",
                action: MZ.SpriteCircleCollider(sprite: sprite, offset: CGPoint.zero, collisionScale: 1)
            )
        }

        func addMoveVectorToActor(actor: MZ.Actor, move: CGPoint) {
            actor.addActionWithName("move", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.position += move }
            }
        }

        addColliderToActor(_actor1)
        addColliderToActor(_actor2)

        addMoveVectorToActor(_actor1, actor1MoveVectors[_currentTestingCount])
        addMoveVectorToActor(_actor2, actor2MoveVectors[_currentTestingCount])

        _actor1.position = actor1Pos[_currentTestingCount]
        _actor2.position = actor2Pos[_currentTestingCount]

        _actor1.scale = MZ.Maths.randomFloat(min: 0.5, max: 1.5)
        _actor2.scale = MZ.Maths.randomFloat(min: 0.5, max: 1.5)
    }

    private func _setTestState3() {
        println("\t--> 測試 offset")

        let center = CGPoint(size: scene.size / 2)

        let actor1Pos = [
            center - CGPoint(x: 15, y: 200),
            center - CGPoint(x: 200, y: 0),
            center - CGPoint(x: 100, y: 100),
        ]
        let actor1MoveVectors = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ]

        let actor2Pos = [
            center + CGPoint(x: 15, y: 200),
            center + CGPoint(x: 200, y: 0),
            center + CGPoint(x: 100, y: 100)
        ]
        let actor2MoveVectors = [
            CGPoint(x: 0, y: -1),
            CGPoint(x: -1, y: 0),
            CGPoint(x: -1, y: -1)
        ]

        func addColliderToActor(actor: MZ.Actor) {
            let nodes = actor.actionWithName("nodes") as MZ.Nodes
            let sprite = nodes.nodeInfoWithName("sprite")!.node as SKSpriteNode

            actor.addActionWithName(
                "collider",
                action: MZ.SpriteCircleCollider(sprite: sprite, offset: CGPoint(x: 25, y: 25), collisionScale: 1)
            )
        }

        func addMoveVectorToActor(actor: MZ.Actor, move: CGPoint) {
            actor.addActionWithName("move", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.position += move }
            }
        }

        func addRotationAction(actor: MZ.Actor) {
            actor.addActionWithName("rotation", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.rotation += 1 }
            }
        }

        addColliderToActor(_actor1)
        addColliderToActor(_actor2)

        addMoveVectorToActor(_actor1, actor1MoveVectors[_currentTestingCount])
        addMoveVectorToActor(_actor2, actor2MoveVectors[_currentTestingCount])

        addRotationAction(_actor1)
        addRotationAction(_actor2)

        _actor1.position = actor1Pos[_currentTestingCount]
        _actor2.position = actor2Pos[_currentTestingCount]

        _actor1.scale = 0.5
        _actor2.scale = 0.5
    }

    private func _setTestState4() {
        println("\t--> 測試多個 collider")

        let center = CGPoint(size: scene.size / 2)

        let actor1Pos = [
            center - CGPoint(x: 15, y: 200),
            center - CGPoint(x: 200, y: 0),
            center - CGPoint(x: 100, y: 100),
        ]
        let actor1MoveVectors = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ]

        let actor2Pos = [
            center + CGPoint(x: 15, y: 200),
            center + CGPoint(x: 200, y: 0),
            center + CGPoint(x: 100, y: 100)
        ]
        let actor2MoveVectors = [
            CGPoint(x: 0, y: -1),
            CGPoint(x: -1, y: 0),
            CGPoint(x: -1, y: -1)
        ]

        func addCollidersToActor(actor: MZ.Actor) {
            let nodes = actor.actionWithName("nodes") as MZ.Nodes
            let sprite = nodes.nodeInfoWithName("sprite")!.node as SKSpriteNode

            let colliderPositions = [
                CGPoint(x: 0, y: 50),
                CGPoint(x: 0, y: 25),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: -25),
                CGPoint(x: 0, y: -50),
                CGPoint(x: 25, y: -50),
                CGPoint(x: 50, y: -50),
            ]

            for (ix, p) in enumerate(colliderPositions) {
                actor.addActionWithName(
                    "collider" + ix.description,
                    action: MZ.SpriteCircleCollider(sprite: sprite, offset: p, collisionScale: 0.5)
                )
            }
        }

        func addMoveVectorToActor(actor: MZ.Actor, move: CGPoint) {
            actor.addActionWithName("move", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.position += move }
            }
        }

        func addRotationAction(actor: MZ.Actor) {
            actor.addActionWithName("rotation", action: MZ.Action()) {
                [weak actor] (a) in
                a.updateAction = { (_) in actor!.rotation += 1 }
            }
        }

        addCollidersToActor(_actor1)
        addCollidersToActor(_actor2)

        addMoveVectorToActor(_actor1, actor1MoveVectors[_currentTestingCount])
        addMoveVectorToActor(_actor2, actor2MoveVectors[_currentTestingCount])

        addRotationAction(_actor1)
        addRotationAction(_actor2)

        _actor1.position = actor1Pos[_currentTestingCount]
        _actor2.position = actor2Pos[_currentTestingCount]
        
        _actor1.scale = 0.25
        _actor2.scale = 0.5
    }
}