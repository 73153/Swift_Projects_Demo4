import Foundation
import SpriteKit

public class TestActionsChangeTimeScaleOnFly: MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "Test Actions Change Time Scale On Fly"

    public var description: String! = "多 Actions 使用同一個 actionTime, Time Scale 的 runtime 切換"

    public var isDone: Bool { get { return _isTestEnd } }

    init() {}

    deinit {}

    public func start() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _actionTime.timeScale = 1

        _setLabelAndButtons()

        var numberOfActions = 4
        for i in 1...numberOfActions {
            var interval = scene.size.height / 6

            _addNewActionWithActionTime(
                _actionTime,
                position: CGPoint(x: 0, y: interval * CGFloat(i)),
                velocity: MZFloat(10 * i)
            )
        }
    }

    public func update(currentTime: NSTimeInterval) {
        _actionTime.update(currentTime: currentTime)
        _actions.map { (a) in a.update() }
    }

    public func end() {
        _testLayer.removeFromParent()
    }



    private var _isTestEnd: Bool = false

    private var _testLayer: SKNode!

    var _actionTime = MZ.ActionTime()

    var _actions: Array<MZ.Action> = Array<MZ.Action>()

    private func _setLabelAndButtons() {
        let timeScaleButton = SKLabelNode(fontNamed: "Helvetica")
        _testLayer.addChild(timeScaleButton)
        timeScaleButton.text = String(format: "x%0.2f", _actionTime.timeScale)
        timeScaleButton.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 30)
        timeScaleButton.addTouch(type: MZ.TouchType.Began, touchAction: {
            [weak self] (sender, touches, event) in
            switch self!._actionTime.timeScale {
            case 1: self!._actionTime.timeScale = 2
            case 2: self!._actionTime.timeScale = 4
            case 4: self!._actionTime.timeScale = 8
            case 8: self!._actionTime.timeScale = 0.25
            case 0.25: self!._actionTime.timeScale = 0.5
            case 0.5: self!._actionTime.timeScale = 1
            default: self!._actionTime.timeScale = 1
            }

            (sender as SKLabelNode).text = String(format: "x%0.2f", self!._actionTime.timeScale)
        })

        let endButton = SKLabelNode(fontNamed: "Comic San MS")
        _testLayer.addChild(endButton)
        endButton.position = timeScaleButton.position + CGPoint(x: 0, y: -40)
        endButton.text = "End Test"
        endButton.addTouch(type: MZ.TouchType.Began, touchAction: {
            [weak self] (_, _, _) in
            self!._isTestEnd = true
        })
    }

    private func _addNewActionWithActionTime(actionTime: MZ.ActionTime, position: CGPoint, velocity: MZFloat) {
        var sprite = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 30, height: 30))
        _testLayer.addChild(sprite)
        sprite.position = position

        var action = MZ.Action()
        action.actionTime = actionTime

        action.isActiveFunc = { (_) in true }
        action.updateAction = {
            [weak self] (a) in
            sprite.position.x += CGFloat(a.deltaTime * velocity)
            if sprite.position.x > self!.scene.size.width {
                sprite.position.x = 0
            }
        }

        _actions.append(action)
    }
}