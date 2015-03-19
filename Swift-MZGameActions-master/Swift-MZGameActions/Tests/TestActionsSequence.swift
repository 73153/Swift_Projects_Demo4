import Foundation
import SpriteKit

@objc public class TestActionsSequence : MZPQueueActionElemnt {

    let MAX_ACTION_TIMES = 5

    public var scene: SKScene!

    public var title: String! = "TestActionsSequence"

    public var description: String! = "測試 ActionsSequence\n" +
        "\tUpdating 中 isActive == true 是否恆真"

    public var isDone: Bool { get { return _sequenceActions.isActive == false } }

    init() {}

    public func start() {
        _setSequencePrint()
        _setSequenceActions()
    }

    public func update(currentTime: NSTimeInterval) {
        _sequencePrint.update()

        _sequenceActions.update()
        _monitorActiveStateOfSequenceActionsIfNeed()
    }

    public func end() {
        println("")
        _testLayer.removeFromParent()
    }



    // MARK: Private

    private var _testLayer : SKNode!

    private var _testSquare : SKSpriteNode!

    private var _sequencePrint : MZ.ActionsSequence!

    private var _sequenceActions : MZ.ActionsSequence!

    private var _maxSequenceActionsDuration : MZFloat = 0

    private var _currentActionTimes = 0

    private func _setSequencePrint() {
        var a = MZ.Action(); a.isActiveFunc = { (_) in  false }; a.startAction = { (_) in print("a") }
        var b = MZ.Action(); b.isActiveFunc = { (_) in  false }; b.startAction = { (_) in print("b") }
        var c = MZ.Action(); c.isActiveFunc = { (_) in  false }; c.startAction = { (_) in print("c") }
        var d = MZ.Action(); d.isActiveFunc = { (_) in  false }; d.startAction = { (_) in print("d\n") }

        _sequencePrint = MZ.ActionsSequence(actions: a, b, c, d)
    }

    private func _setSequenceActions() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _testSquare = SKSpriteNode(color: SKColor.purpleColor(), size: CGSize(width: 40, height: 40))
        _testLayer.addChild(_testSquare)
        _testSquare.position = CGPoint(x: 45, y: 45)

        var velocity = 50.0

        var durationPerTime = 0.5

        _maxSequenceActionsDuration = durationPerTime * 2.0 * MZFloat(MAX_ACTION_TIMES)

        func newActionToLeft() -> MZ.Action {
            return MZ.Action() {
                (action) in
                action.duration = durationPerTime
                action.updateAction = { (a) in self._testSquare.position.x += CGFloat(velocity * a.deltaTime) }
            }
        }

        func newActionToUp() -> MZ.Action {
            var action = MZ.Action()
            action.duration = durationPerTime
            action.updateAction = { (a) in self._testSquare.position.y += CGFloat(velocity * a.deltaTime) }
            action.endAction = { (_) in
                self._currentActionTimes++
                println("done times = \(self._currentActionTimes)")
            }

            return action
        }

        _sequenceActions = MZ.ActionsSequence()
        for i in 1...MAX_ACTION_TIMES {
            _sequenceActions.addAction(newActionToLeft())
            _sequenceActions.addAction(newActionToUp())
        }

        _sequenceActions.addAction(MZ.Action()) {
            (action) in
            action.isActiveFunc = { (_) in false }
            action.startAction = {
                (_) in
                MZ.assert(self._currentActionTimes == self.MAX_ACTION_TIMES, "sequence count is not match")
                println("次數驗證 ok")
            }
        }

        _sequenceActions.addAction(MZ.Wait(wait: 1))

        _sequenceActions.addAction(MZ.Action(name: "turn off Active State Monitor")) {
            (a) in
            a.isActiveFunc = { (_) in false }
            a.startAction = { (_) in self._needToMonitorActiveStateOfSequenceActions = false }
        }
    }

    private var _needToMonitorActiveStateOfSequenceActions = true

    func _monitorActiveStateOfSequenceActionsIfNeed() {
        if !_needToMonitorActiveStateOfSequenceActions { return }
        MZ.assert(_sequenceActions.isActive, "_sequenceActions.isActive should be TRUE")
    }
}
