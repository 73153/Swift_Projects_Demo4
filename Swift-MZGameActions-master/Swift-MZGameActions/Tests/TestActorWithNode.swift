import Foundation
import SpriteKit

@objc public class TestActorWithNode : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 Actor"

    public var description: String! = "測試 Actor + Nodes, 主要為 transform 是否正確運作"

    public var isDone: Bool { get { return _endTest } }

    init() {}

    public func start() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _addNewActor()
    }

    public func update(currentTime: NSTimeInterval) {
        _updaters.update()
    }

    public func end() {
        _testLayer.removeFromParent()
    }



    // MARK: Private

    private var _testLayer : SKNode!

    private var _updaters = MZ.ActionsGroup()

    private var _endTest = false

    private func _addNewActor() {
        var actor = MZ.Actor()

        actor.addAction(MZ.Nodes(name: "nodes")) {
            (nodes) in

            var center = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 20, height: 20))
            self._testLayer.addChild(center)
            nodes.addNewNodeInfo(node: center, name: "center") {
                (nodeInfo) in
                nodeInfo.originPosition = CGPoint(x: 0, y: 0)
            }

            var left = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 40, height: 20))
            self._testLayer.addChild(left)
            nodes.addNewNodeInfo(node: left, name: "left") {
                (nodeInfo) in
                nodeInfo.originPosition = CGPoint(x: 10, y: 20)
            }

            var right = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 40, height: 20))
            self._testLayer.addChild(right)
            nodes.addNewNodeInfo(node: right, name: "right") {
                (nodeInfo) in
                nodeInfo.originPosition = CGPoint(x: 10, y: -20)
            }
        }

        actor.position = CGPoint(x: scene.size.width / 2, y: 0)

        actor.addAction(MZ.Action(name: "move")) {
            (a) in a.updateAction = { (_) in actor.position.y += CGFloat(100.0 * a.deltaTime) }
        }

        actor.addAction(MZ.Action(name: "rotation")) {
            (a) in a.updateAction = { (_) in actor.rotation += 180.0 * a.deltaTime }
        }

        // scale
        actor.addAction({
            () -> MZ.ActionRepeat in
            var scaleUp = MZ.Action() {
                (a) in
                a.duration = 0.5
                a.updateAction = { (_) in actor.scale += 1 * a.deltaTime }
            }

            var scaleDown = MZ.Action() {
                (a) in
                a.duration = 0.5
                a.updateAction = { (_) in actor.scale -= 1 * a.deltaTime }
            }

            var seq = MZ.ActionsSequence(actions: scaleUp, scaleDown)

            return MZ.ActionRepeat(foreverAction: seq)
        }())

        actor.addAction(MZ.Action(name: "end monitor")) {
            (a) in
            a.updateAction = { (_) in if actor.position.y >= self.scene.size.height { self._endTest = true } }
        }

        _updaters.addAction(actor)
    }
}