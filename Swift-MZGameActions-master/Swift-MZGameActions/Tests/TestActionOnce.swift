import Foundation
import SpriteKit

public class TestActionOnce: MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "TestOnceAction"

    public var description: String! = "Test: 一次性 Action, 只會直行 start(), end() 各一次"

    public var isDone: Bool { get { return true } }

    init() {}

    public func start() {
        var onceAction = MZ.Action()
        onceAction.isActiveFunc = { (_) in false }

        var pass: (String) -> () = { (message) in println("pass: \(message)") }
        var fail: (String) -> () = { (message) in println("fail: \(message)"); abort() }

        onceAction.startAction = {
            (a) in
            pass("start")
            a.startAction = { (_) in fail("can not start() again") }
        }
        onceAction.updateAction = { (_) in fail("update") }
        onceAction.endAction = {
            (a) in
            pass("end")
            a.endAction = { (_) in fail("can not end() again") }
        }

        for i in 1...5 {
            onceAction.update()
            MZ.assert(onceAction.isActive == false, "onceAction.isActive should be FALSE")
        }
    }

    public func update(currentTime: NSTimeInterval) {}
    
    public func end() {}
}
