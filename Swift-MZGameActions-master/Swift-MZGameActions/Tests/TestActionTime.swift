import Foundation
import SpriteKit

public class TestActionTime : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 ActionTime"

    public var description: String! = ""

    public var isDone: Bool { get { return _timeActionTime.passedTime >= 5 } }

    init() {}

    public func start() {

    }

    public func update(currentTime: NSTimeInterval) {
        _frameActionTime.update(currentTime: currentTime)
        _timeActionTime.update(currentTime: currentTime)

        println(_frameActionTime.deltaTime)
        println(_timeActionTime.deltaTime)
    }

    public func end() {
    }



    // MARK: Private

    private var _frameActionTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Frame)

    private var _timeActionTime = MZ.ActionTime(timeMode: MZ.ActionTime.TimeMode.Time)
}
