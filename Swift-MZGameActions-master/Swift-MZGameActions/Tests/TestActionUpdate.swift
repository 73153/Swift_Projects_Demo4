import Foundation
import SpriteKit

public class TestActionUpdate: MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "TestUpdateAction"

    public var description: String! = "測試 Action 實際的 update"

    public var isDone: Bool { get { return _action.isActive == false } }

    init() {}

    public func start() {
        let duration: MZFloat = 2

        _action = MZ.Action()

        _action.duration = duration

        _action.startAction = { (a) in println("i start for the live, passed = \(a.passedTime)") }
        _action.endAction = { (a) in println("i end for the live, passed = \(a.passedTime)") }
    }

    public func update(currentTime: NSTimeInterval) {
        _action.update()

        if _action.passedTime < _duration {
            MZ.assert(
                _action.isActive,
                "less than duration(%0.2f, passed=%0.2f) but isActive is false",
                _duration,
                _action.passedTime
            )
        }

        if _action.passedTime >= _duration {
            MZ.assert(
                _action.isActive == false,
                "over than duration(%0.2f, passed=%0.2f) but isActive is true",
                _duration,
                _action.passedTime
            )
        }
    }

    public func end() {}



    // MARK: Private

    private let _duration: MZFloat = 2

    private var _action: MZ.Action! = nil
}
