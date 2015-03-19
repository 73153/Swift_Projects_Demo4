import Foundation
import SpriteKit

@objc public class TestActionsGroupAddRevmoeOnFly : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "TestActionsGroupAddRevmoeOnFly"

    public var description: String! = "測試 ActionsGroup 的增減"

    public var isDone: Bool { get { return _isDone } }

    init() {}

    public func start() {
//        _testSwithInArrayChange()
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _actionsGroup = MZ.ActionsGroup()

        _testImmediatedRemove()

        _addNewTimeToInvokeToQueue(time: 0.5, invoke: _addLateActionAndRemoveIt)
        _addNewTimeToInvokeToQueue(time: 1.0, invoke: _addActionOnFly)
        _addNewTimeToInvokeToQueue(time: 1.5, invoke: _testGroupActionOnFly)
        _addNewTimeToInvokeToQueue(time: 2.0, invoke: _removeActionOnFly)
        _addNewTimeToInvokeToQueue(time: 2.5, invoke: _addActionToCreateOthers)
        _addNewTimeToInvokeToQueue(time: 3.0, invoke: _removeLateOnFly)
        _addNewTimeToInvokeToQueue(time: 3.5, invoke: _verifyAfterRemoveOnFly)

        _addNewTimeToInvokeToQueue(time: 4.0, invoke: _endTest)
    }

    public func update(currentTime: NSTimeInterval) {
        _timer.update(currentTime: currentTime)

        _actionsGroup.update()

        if _invokeAtTimeQueue.count == 0 { return }

        if _timer.passedTime >= _invokeAtTimeQueue.first!.time {
            _invokeAtTimeQueue.first!.invoke()
            _invokeAtTimeQueue.removeAtIndex(0)
        }
    }
    
    public func end() {

    }



    // MARK: Private

    class InvokeAtTime {
        var invoke: ()->()
        var time: MZFloat

        init(time: MZFloat, invoke: ()->()) {
            self.invoke = invoke
            self.time = time
        }
    }

    private var _isDone = false

    private var _testLayer : SKNode!

    private var _timer = MZ.ActionTime()

    private var _actionsGroup : MZ.ActionsGroup!

    private var _invokeAtTimeQueue = Array<InvokeAtTime>()

    private func _testSwithInArrayChange() {
        println("測試: Swift 的 Array 循環做動態增減")
        println("(不過我想還是保持原 AddLate 的設計)")

        var array = [1, 2, 3, 4, 5]

        // 依然是取目前的 array 內容, 所以只會輸出 1,2,3,4,5
        for i in array {
            array.append(array.count+1)
            println(i)
        }
        println(array) // => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        println("Array 循環中 append --> ok")

        println("Array 循環中 insert --> ok")
        for ix in 0..<array.count {
            array.insert(77, atIndex: ix + 1)
            println(array[ix])
        }
        println(array)

//        for ix in 0..<array.count {
//            array.removeAtIndex(ix + 1)
//        }
//        println(array)
        println("Array 循環中刪除 --> out")
    }

    private func _testImmediatedRemove() {
        println("測試立即移除")

        var immediatedRemoveAction = _newImmediatedRemoveAction()
        _actionsGroup.addAction(immediatedRemoveAction)
        MZ.assert(_actionsGroup.updatingActions.count == 1, "updatingActions.count must be one")

        _actionsGroup.removeAction(immediatedRemoveAction)
        MZ.assert(_actionsGroup.updatingActions.count == 0, "updatingActions.count must be zero")
    }

    private func _newImmediatedRemoveAction() -> MZ.Action {
        var action = MZ.Action()
        action.isActiveFunc = { (_) in return true }

        action.endAction = { (_) in MZ.assertAlwayFalse("can not here") }


        return action
    }

    private func _addLateActionAndRemoveIt() {
        println("測試: 加入後立刻移除")

        let preActionsCount = _actionsGroup.count

        var action = _newImmediatedRemoveAction()
        _actionsGroup.addAction(action)

        MZ.assert(preActionsCount + 1 == _actionsGroup.count, "issue")

        _actionsGroup.removeAction(action)
        MZ.assert(preActionsCount == _actionsGroup.count, "issue")
    }

    private func _addNewTimeToInvokeToQueue(#time: MZFloat, invoke: ()->()) {
        _invokeAtTimeQueue.append(InvokeAtTime(time: time, invoke: invoke))
    }

    private func _addActionOnFly() {
        println("測試: 加入一筆等待 n 秒後會被移除的 action")

        var preCount = _actionsGroup.count

        var a = MZ.Action(name: "remove me")

        _actionsGroup.addAction(a)

        MZ.assert(_actionsGroup.count == preCount + 1, "Add new action, but count is not correct")
        MZ.assert(_actionsGroup.updatingActions.count == preCount, "Add new action to late, but count is changed")
    }

    private func _testGroupActionOnFly() {
        println("測試狀態")
        MZ.assert(_actionsGroup.updatingActions.count == 1, "must to one")
    }

    private func _removeActionOnFly() {
        println("測試移除")
        _actionsGroup.removeActionWithName("remove me")
        MZ.assert(_actionsGroup.updatingActions.count == 0, "must to zero")
    }

    private func _addActionToCreateOthers() {
        println("測試: 投入一個 action, 其在 updting 終會增加其他的 action 到 actionsGroup 中")

        var action = MZ.Action(name: "create others")

        action.isActiveFunc = { (_a) in _a.passedTime < 0.1 }

        action.updateAction = {
            [weak self] (_) in
            var a = MZ.Action(name: "I am #" + String(self!._actionsGroup.count - 1))
            self!._actionsGroup.addAction(a)
            println("added => count = \(self!._actionsGroup.count)" )
            // 雖然因為 Swift Array 的設計, 循環中 append 是 ok 的, 但還是不要用, 維持原始的 buffer
        }

        _actionsGroup.addAction(action)
    }

    private func _removeLateOnFly() {
        let preCount = _actionsGroup.count

        _actionsGroup.removeActionLateWithName("I am #1")

        MZ.assert(_actionsGroup.count == preCount, "bcuz remove is late, so count should not changed")
    }

    private func _verifyAfterRemoveOnFly() {
        println("\(_actionsGroup.count)")
    }

    private func _endTest() {
        _isDone = true
    }
}
