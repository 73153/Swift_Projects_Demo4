import Foundation
import SpriteKit
import CoreGraphics
import Darwin

public class TestMoves : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = ""

    public var description: String! = ""

    public var isDone: Bool { get { return false } }

    init() {}

    public func start() {
        scene.addChild(_nodesLayer)
        _updaters.actionTime = _time

        let center = CGPoint(size: scene.size / 2)

        _mainTester = _newReachAtTimeMoverAt(CGPoint.zero)

        _newVelocityDirection()
        _newTurnFromToAt(center, from: 0, to: 181)
        _newMoveFollowAt(CGPoint(x: 50, y: scene.size.height - 30))
        _newRoundAt(CGPoint(size: scene.size / 2) + CGPoint(x: 100, y: 0))
        _newRoundWithMainTesterAt(CGPoint(x: 30, y: 0))
        _newTurnFromToInDurationGroup()


        _mainTester?.addAction(MZ.Action()) {
            [weak self] (a) in
            a.updateAction = {
                (_) in
                if !CGPointEqualToPoint(self!._mainTester!.position, CGPoint(x: 200, y: 300)) {
                    return
                }
                self!._updaters.removeAction(self!._mainTester!)
                self!._mainTester = nil
            }
        }

        _updaters.start()
    }

    public func update(currentTime: NSTimeInterval) {
        _time.update(currentTime: currentTime)
        _updaters.update()
    }

    public func end() {
        _updaters.end()
        _updaters.removeAllActions()
        _nodesLayer.removeFromParent()
    }



    // MARK: Private

    private var _nodesLayer = SKNode()

    private var _time = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame, fps: 30)

    private var _updaters = MZ.ActionsGroup()

    private var _mainTester: MZ.Actor?

    private func _newVelocityDirection() -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 30, height: 15))
        _nodesLayer.addChild(sprite)

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body")
            return
        }

        mover.addAction(MZ.Moves.VelocityDirection(mover: mover)) {
            (move) in
            move.velocity = 100
            move.direction = 270
        }
        
        return mover
    }

    private func _newReachAtTimeMoverAt(position: CGPoint) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 30, height: 15))
        _nodesLayer.addChild(sprite)

        let dest = position + CGPoint(x: 200, y: 300)
        mover.addAction(MZ.Moves.ReachAtTime(mover: mover, destination: dest, duration: 3))

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body")
            return
        }

        _addFaceToDirectionToActor(mover)

        mover.position = position

        return mover
    }

    private func _newTurnFromToAt(position: CGPoint, from: MZFloat, to: MZFloat) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: 30, height: 15))
        _nodesLayer.addChild(sprite)

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body")
            return
        }

        mover.addAction(MZ.Moves.TurnFromTo(mover: mover, from: from, to: to, degreesVelocity: 100, velocity: 50))

        _addFaceToDirectionToActor(mover)

        mover.position = position

        return mover
    }

    private func _newMoveFollowAt(position: CGPoint) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 30, height: 15))
        _nodesLayer.addChild(sprite)

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body")
            return
        }

        var followTargetFunc = {
            [weak self] () -> (CGPoint?) in
            var target = self?._mainTester
            if target == nil { return nil }

            return target!.position
        }

        mover.addAction(MZ.Moves.Follow(mover: mover, targetFunc: followTargetFunc)) {
            (move) in
            move.velocity = 50
            return
        }

        _addFaceToDirectionToActor(mover)
        
        mover.position = position
        
        return mover
    }

    private func _newRoundAt(position: CGPoint) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.purpleColor(), size: CGSize(width: 24, height: 12))
        _nodesLayer.addChild(sprite)

        var centerFunc = { [weak self] () -> (CGPoint?) in return CGPoint(size: self!.scene.size / 2) }

        mover.addAction(MZ.Moves.Round(mover: mover, centerFunc: centerFunc)) {
            (move) in
            move.degreesVelocity = 50
            return
        }

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body")
            return
        }

        _addFaceToDirectionToActor(mover)

        mover.position = position
        
        return mover
    }

    private func _newRoundWithMainTesterAt(position: CGPoint) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: 10, height: 4))
        _nodesLayer.addChild(sprite)

        mover.addAction(MZ.Nodes()) {
            (nodes) in
            nodes.addNewNodeInfo(node: sprite, name: "body")
            return
        }

        mover.addAction(MZ.Moves.Round(
            mover: mover,
            centerFunc: {
                [weak self] in
                return self!._mainTester != nil ? self!._mainTester!.position : nil
        })) {
            (move) in
            move.degreesVelocity = 100
            return
        }

        _addFaceToDirectionToActor(mover)

        mover.position = position

        return mover
    }

    private func _newTurnFromToInDurationGroup() {
        for i in 0..<4 {
            let fromDegrees: [MZFloat] = [0, 90, 180, 270]
            let toDegrees:   [MZFloat] = [45, 135, 225, 315]

            _newTurnFromToInDuration(
                from: fromDegrees[i],
                to: toDegrees[i],
                duration: 1.0,
                at: CGPoint(size: scene.size / 2)
            )
        }

        for i in 0..<4 {
            let fromDegrees: [MZFloat] = [0, 90, 180, 270]
            let toDegrees:   [MZFloat] = [-90, 0, 90, 180]

            _newTurnFromToInDuration(
                from: fromDegrees[i],
                to: toDegrees[i],
                duration: 1.0,
                at: CGPoint(size: scene.size / 2),
                color: SKColor.orangeColor()
            )
        }
    }

    private func _newTurnFromToInDuration(
        #from: MZFloat,
        to: MZFloat,
        duration: MZFloat = 1,
        at: CGPoint,
        color: SKColor = SKColor.brownColor()
    ) -> MZ.Actor {
        var mover = _updaters.addAction(MZ.Actor())

        var sprite = SKSpriteNode(color: color, size: CGSize(width: 10, height: 4))
        _nodesLayer.addChild(sprite)

        mover.addAction(MZ.Nodes()) {
            [weak sprite] (nodes) in
            nodes.addNewNodeInfo(node: sprite!, name: "body"); return
        }

        mover.addAction(MZ.Moves.TurnFromToInDuration(mover: mover, from: from, to: to, duration: duration)) {
            (m) in
            m.velocity = 100; return
        }

        _addFaceToDirectionToActor(mover)

        mover.position = at

        return mover
    }

    private func _addFaceToDirectionToActor(actor: MZ.Actor) {
        actor.addAction(MZ.Action()) {
            [weak actor] (a) in
            if actor == nil { return }

            a.updateAction = {
                (_) in
                let moves = actor!.actionsWithBaseClass(MZ.Moves.Base.self) as [MZ.Moves.Base]
                actor!.rotation = moves.first!.currentDirection
            }
        }
    }

    private func _followPathSmallPieceTest() {
        var s = SKSpriteNode(color: SKColor.orangeColor(), size: CGSize(width: 12, height: 12))
        //        var path = CGPathCreateWithRect(
        //            CGRect(center: CGPoint(size: scene.size / 2), size: scene.size * 0.4),
        //            nil
        //        )
        var path = CGPathCreateWithEllipseInRect(
            CGRect(center: CGPoint(size: scene.size / 2), size: scene.size * 0.4),
            nil
        )
        s.runAction(SKAction.repeatActionForever(SKAction.followPath(path, speed: 100)))
        _nodesLayer.addChild(s)
    }
}