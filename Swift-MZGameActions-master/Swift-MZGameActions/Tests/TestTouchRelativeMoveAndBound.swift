import Foundation
import SpriteKit

public class TestTouchRelativeMoveAndBound : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試相對移動操作(TouchRelativeMove)"

    public var description: String! = ""

    public var isDone: Bool { get { return _endTest } }

    init() {}

    public func start() {
        _testLayer = TouchNotifierLayer(color: SKColor(red: 1, green: 1, blue: 1, alpha: 0), size: scene.size)
        _testLayer.anchorPoint = CGPoint(x: 0, y: 0)
        scene.addChild(_testLayer)

        _character = _newCharacter()

        var endButton = SKLabelNode(text: "I think it's fine")
        _testLayer.addChild(endButton)
        endButton.position = CGPoint(x: _testLayer.size.width / 2, y: _testLayer.size.height - 40)
        endButton.addTouch(type: MZ.TouchType.Began, touchAction: { (_) in self._endTest = true })
    }

    public func update(currentTime: NSTimeInterval) {

    }

    public func end() {
        _testLayer.removeFromParent()
    }



    // MARK: Private

    private var _testLayer : TouchNotifierLayer!

    private var _character: MZ.Actor!

    private var _endTest = false

    func _newCharacter() -> MZ.Actor {
        var character = MZ.Actor(name: "tester")

        character.addActionWithName(
            "sprite",
            action: {
                var s = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 20, height: 20))
                self._testLayer.addChild(s)

                var nodes = MZ.Nodes()
                nodes.addNewNodeInfo(node: s, name: "color-rect")

                return nodes
            }()
        )

        var bound = CGRect(origin: CGPoint.zero, size: _testLayer.size * 0.8)
        bound.center = CGPoint(size: _testLayer.size / 2)

        character.addActionWithName(
            "touch-relative-move",
            action: MZ.TouchRelativeMove(mover: character, touchNotifier: _testLayer, bound: bound)
        )

        character.position = CGPoint(x: _testLayer.size.width / 2, y: _testLayer.size.height / 2)

        var boundShape = SKShapeNode(rect: bound)
        _testLayer.addChild(boundShape)
        boundShape.strokeColor = SKColor.whiteColor() // not work now ... ><
        boundShape.fillColor = SKColor(red: 1, green: 0.5, blue: 0, alpha: 0.2)
        boundShape.lineWidth = 2

        return character
    }

    class TouchNotifierLayer : SKSpriteNode, MZPTouchNotifier {

        func addTouchResponder(touchResponder: AnyObject) {
            self.userInteractionEnabled = true
            _touchResponders.append(touchResponder as MZPTouchResponder)
        }

        func removeTouchResponder(touchResponder: AnyObject) {
            var index: Int? = nil
            for i in 0..<_touchResponders.count {
                if _touchResponders[i] === touchResponder { index = i; break }
            }

            if index != nil { _touchResponders.removeAtIndex(index!) }
        }

        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            _touchResponders.map { (t) in t.touchesBegan(touches) }
        }

        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            _touchResponders.map { (t) in t.touchesMoved(touches) }
        }

        override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            _touchResponders.map { (t) in t.touchesEnded(touches) }
        }

        func positionWithTouch(touch: UITouch) -> CGPoint {
            return touch.locationInNode(self)
        }



        // MARK : Private

        var _touchResponders = [MZPTouchResponder]()
    }
}
