import Foundation
import SpriteKit

public class TestActionsGroup: MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "TestActionsGroup"

    public var description: String! =
        "同時多個 Actions Update\n" +
        "用途: 事件機, 角色\n" +
        "測試項目: \n" +
            "\t(1) 測試 ActionsGroup 是否有在所有內含的 Actions 結束後結束\n" +
            "\t(2) 測試 removeInactiveActions()"

    public var isDone: Bool { get { return _testTimer.passedTime >= 6 } }

    init() {}

    deinit {}

    public func start() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _testGetActionWithClassInGroup()

        _actionsGroup = MZ.ActionsGroup()
        _actionsGroup.start()

        _actionsGroup.addAction(_newTestActionWithDuration(1))
        _actionsGroup.addAction(_newTestActionWithDuration(5))
        _actionsGroup.addAction(_newTestActionWithDuration(2))
        _actionsGroup.addAction(_newTestActionWithDuration(4))

        MZ.assert(
            _actionStartCount == _MAX_INTERNAL_ACTIONS,
            "I added 4 actions but start count is %d", _actionStartCount
        )
    }

    public func update(currentTime: NSTimeInterval) {
        _testTimer.update(currentTime: currentTime)

        _actionsGroup.update()
        _verifyGroupActive()

        _actionsGroup.removeInactiveActions()
        _verifyGroupRemvoeInactive()
        
        _verifyGroupEnd()
    }

    public func end() {
        _testLayer.removeFromParent()
    }



    private let _MAX_INTERNAL_ACTIONS = 4

    private var _testLayer: SKNode!

    private var _testTimer = MZ.ActionTime()

    private var _actionsGroup: MZ.ActionsGroup!

    private var _actionStartCount: Int = 0

    private var _actionsEndCount: Int = 0

    private func _testGetActionWithClassInGroup() {
        println("\t-- 測試 actionsWithClass() --")
        var testGroup = MZ.ActionsGroup()

        testGroup.addAction(MZ.Action(name: "action1"))
        testGroup.addAction(MZ.Action(name: "action2"))
        testGroup.addAction(MZ.Actor(name: "actor"))
        testGroup.addAction(MZ.Wait(wait: 0)) { (a) in a.name = "delay" }
        testGroup.addAction(MZ.Action(name: "action3"))

        var actions = testGroup.actionsWithClass(MZ.Action.self)
        MZ.assert(actions.count == 3, "actions of MZ.Action should be 3, but %d", actions.count)

        for i in 0..<actions.count {
            let aname = "action" + String(i + 1)
            MZ.assert(actions[i].name == aname, "action name should be %@, but %@", aname, actions[i].name)
        }

        var waits = testGroup.actionsWithClass(MZ.Wait.self)
        MZ.assert(waits.count == 1, "actions of MZ.Wait should be 1, but %d", waits.count)

        var notExistAction = testGroup.actionsWithClass(MZ.Nodes.self)
        MZ.assert(notExistAction.count == 0, "actions of MZ.Nodes should be 0, but %d", waits.count)

        println("\t-- ok --")
    }

    private func _newTestActionWithDuration(duration: MZFloat) -> MZ.Action {
        var action = MZ.Action()
        action.duration = duration
        action.startAction = { (_) in self._actionStartCount = self._actionStartCount + 1 }
        action.endAction = { (_) in self._actionsEndCount = self._actionsEndCount + 1 }

        return action
    }

    private func _verifyGroupActive() {
        if _actionsGroup.passedTime <= 5 {
            MZ.assert(_actionsGroup.isActive, "less than 5, but actionsGroup.isActive != true")
        } else {
            MZ.assert(_actionsGroup.isActive == false, "more than 5, but actionsGroup.isActive != false")
        }
    }

    private func _verifyGroupRemvoeInactive() {
        var currentUpdatingActionsCount = _actionsGroup.updatingActions.count
        var shouldBeUpdatingActionsCount = _MAX_INTERNAL_ACTIONS - _actionsEndCount

        MZ.assert(
            currentUpdatingActionsCount == shouldBeUpdatingActionsCount,
            "current actions must be %d, but %d (at passedTime = %0.2f)",
            shouldBeUpdatingActionsCount,
            currentUpdatingActionsCount,
            _actionsGroup.passedTime
        )
    }

    private func _verifyGroupEnd() {
        if _actionsGroup.isActive { return }

        MZ.assert(
            _actionsEndCount == _MAX_INTERNAL_ACTIONS,
            "actionsEndCount(%d) is not equal to total added actions(%d)",
            _actionsEndCount,
            _MAX_INTERNAL_ACTIONS
        )
    }
}