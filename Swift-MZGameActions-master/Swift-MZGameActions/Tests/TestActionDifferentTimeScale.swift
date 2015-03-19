import Foundation
import SpriteKit

public class TestActionDifferentTimeScale: MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "TestActionDifferentTimeScale"

    public var description: String! = "不同的 timeScale"

    public var isDone: Bool {
        get {
            for a in _actions { if a.isActive == true { return false } }
            return true
        }
    }

    init() {}

    public func start() {
        _layer = SKNode()
        scene.addChild(_layer)

        let timeScales: [MZFloat] = [0.25, 0.5, 1, 2, 4]
        let intervalY: CGFloat = scene.size.height / CGFloat(timeScales.count + 1)

        for i in 1...timeScales.count {
            _addNewAtionWithTimeScale(timeScales[i-1], y: CGFloat(i) * intervalY, globalTime: _globalTime)
        }
    }

    public func update(currentTime: NSTimeInterval) {
        _globalTime.update(currentTime: currentTime)
        _actions.map { (a) in a.update() }
    }
    
    public func end() {
        _actions.removeAll(keepCapacity: false)
        _layer.removeFromParent()
    }



    let _globalTime = MZ.ActionTime()

    var _actions: Array<MZ.Action> = Array<MZ.Action>()

    var _layer: SKNode!

    private func _addNewAtionWithTimeScale(timeScale: MZFloat, y: CGFloat, globalTime: MZ.ActionTime) {
        let startX: CGFloat = 30
        let endX: CGFloat = scene.size.width - 30

        let labelX: CGFloat = startX - 10

        let label = SKLabelNode(fontNamed: "Arial")
        _layer.addChild(label)
        label.text = String(format: "tScale = %0.2f", timeScale)
        label.setScale(0.5)
        label.position = CGPoint(x: labelX + 40, y: y + 15)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left

        let sprite = SKSpriteNode(color: SKColor.purpleColor(), size: CGSize(width: 20, height: 20))
        _layer.addChild(sprite)
        sprite.position = CGPoint(x: startX, y: y)

        var action = MZ.Action()
        action.duration = 2
        action.timeScale = timeScale

        action.updateAction = {
            (a) in
            sprite.position += CGPoint(x: 100.0 * a.deltaTime, y: 0)
        }

        action.endAction = {
            (a) in
            label.text = String(format: "Ended passed=%0.2fs, total=%0.2f", a.passedTime, globalTime.passedTime)
        }

        _actions.append(action)
    }
}
