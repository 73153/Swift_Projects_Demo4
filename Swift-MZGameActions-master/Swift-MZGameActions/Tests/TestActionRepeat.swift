// TODO: 沒有加入結束

import Foundation
import SpriteKit

@objc public class TestActionRepeat : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = ""

    public var description: String! = ""

    public var isDone: Bool { get { return false } }

    init() {}

    public func start() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _setActionRepeat()
        _setRepeatWithGroups()
        _setRepeatWithSequenceGroups()
    }

    public func update(currentTime: NSTimeInterval) {
        _updateAndCheckSimpleRepeat()
        _repeatWithGroup?.update()
        _repeatWithSequenceGroup?.update()
    }

    public func end() {}



    // MARK: Private

    private var _simpleRepeat : MZ.ActionRepeat?

    private var _repeatWithGroup : MZ.ActionRepeat?

    private var _repeatWithSequenceGroup : MZ.ActionRepeat?

    private var _currentRepeatTimes = 0

    private var _testLayer : SKNode!

    private func _setActionRepeat() {
        var action = MZ.Action() {
            (a) in
            a.isActiveFunc = { (_) in false }

            a.startAction = {
                (_) in
                self._currentRepeatTimes++
                println("#\(self._currentRepeatTimes) start")
            }

            a.endAction = { (_) in println("#\(self._currentRepeatTimes) end") }
        }

        _simpleRepeat = MZ.ActionRepeat(action: action, repeatTimes: 5)
        _simpleRepeat!.start()
    }

    private func _updateAndCheckSimpleRepeat() {
        if _simpleRepeat == nil { return }

        _simpleRepeat!.update()

        if !_simpleRepeat!.isActive {
            MZ.assert(_currentRepeatTimes == 5, "repeat is ended, but count should be 5")
        }
    }

    private func _setRepeatWithGroups() {
        let origin = CGPoint(x: scene.size.width / 2, y: 30)

        let movements = [CGPoint(x: 20, y: 0), CGPoint(x: -20, y: 0), CGPoint(x: 0, y: 20)]

        var groups = MZ.ActionsGroup()
        for m in movements {
            var sprite = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 20, height: 20))
            _testLayer.addChild(sprite)

            groups.addAction(_newActionWithMovement(m, sprite: sprite, origin: origin))
        }

        _repeatWithGroup = MZ.ActionRepeat(action: groups, repeatTimes: 3)
        _repeatWithGroup!.start()
    }

    private func _setRepeatWithSequenceGroups() {
        let origin = CGPoint(x: scene.size.width / 2, y: 30 * 4)

        let movements = [CGPoint(x: 20, y: 0), CGPoint(x: -20, y: 0), CGPoint(x: 0, y: 20)]

        var groups = MZ.ActionsGroup()
        for m in movements {
            groups.addAction(_newSequenceWithOneWayMovement(m, origin: origin))
        }

        _repeatWithSequenceGroup = MZ.ActionRepeat(action: groups, repeatTimes: 3)
        _repeatWithSequenceGroup!.start()
    }

    func _newActionWithMovement(movement: CGPoint, sprite: SKSpriteNode, origin: CGPoint? = nil) -> MZ.Action {
        return MZ.Action() {
            (action) in
            action.duration = 1.0
            action.startAction = { (a) in
                if origin != nil {
                    sprite.position = origin!
                }
            }
            action.updateAction = {
                (a) in
                sprite.position += movement * CGFloat(a.deltaTime)
            }
        }
    }

    func _newSequenceWithOneWayMovement(movement: CGPoint, origin: CGPoint) -> MZ.ActionsSequence {
        var sprite = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 20, height: 20))
        _testLayer.addChild(sprite);
        sprite.position = origin

        // TODO: 效果不正確 ... debug me >< ...
        var action1 = _newActionWithMovement(movement, sprite: sprite)
        var action2 = _newActionWithMovement(CGPoint(x: -movement.x, y: -movement.y), sprite: sprite)

        var sequence = MZ.ActionsSequence()
        sequence.addAction(action1)
        sequence.addAction(action2)

        return sequence
    }
}

// 測試
// |- 一些自動驗證 ... 測試 updating 中, repeat 的 isActive 狀態