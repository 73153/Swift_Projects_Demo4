// TODO: 沒有加入終止

import Foundation
import SpriteKit

public class TestPoolWithNodes : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 Nodes in Pool!!"

    public var description: String! = "Pool 是否能正確運作, 取得歸還和不足時的狀態\n" +
        "Sprite 狀態還沒有很複雜的說"

    public var isDone: Bool { get { return false } }

    init() {}

    public func start() {
        _testLayer = SKNode()
        scene.addChild(_testLayer)

        _setPool()

        _testOverGetFromPool()

        _nextActionCount = _TEST_ACTION_INTERVAL

        _testActionInvoke = _randomReturnElementsToPool
    }

    public func update(currentTime: NSTimeInterval) {
        let dt = currentTime - _preTime
        _preTime = currentTime

        _nextActionCount -= dt

        if _nextActionCount > 0 { return }
        _testActionInvoke?()
        _nextActionCount = _TEST_ACTION_INTERVAL
    }

    public func end() {
    }



    // MARK: Private

    private let _MAX_POOL_ELEMENTS = 50

    private let _TEST_ACTION_INTERVAL = 1.0

    private var _testLayer: SKNode!

    private var _pool: MZ.Pool!

    private var _usingSprites = [SKSpriteNode]()

    private var _nextActionCount: NSTimeInterval = 0

    private var _testActionInvoke: (()->())? = nil

    private var _preTime: NSTimeInterval = 0

    private func _poolElement() -> SKSpriteNode {
        var color = SKColor(
            red: CGFloat(MZ.Maths.randomFloat()),
            green: CGFloat(MZ.Maths.randomFloat()),
            blue: CGFloat(MZ.Maths.randomFloat()),
            alpha: 0.5
        )

        var sprite = SKSpriteNode(color: color, size: CGSize(width: 20, height: 20))
        _testLayer.addChild(sprite)

        sprite.hidden = true

        return sprite
    }

    private func _setPool() {
        _pool = MZ.Pool(
            numberOfElements: _MAX_POOL_ELEMENTS,
            elementGenFunc: _poolElement,
            getAction: { (pe) in (pe as SKSpriteNode).hidden = false },
            returnAction: { (pe) in (pe as SKSpriteNode).hidden = true }
        )
    }

    private func _testOverGetFromPool() {
        println("測試過量取用")

        for i in 1..._pool.totalElements {
            _getSpriteFromPool()
        }

        for i in 1...10 {
            var overGet = _pool.getElement()
            MZ.assert(overGet == nil, "over get but not nil")
        }

        println("ok")
    }

    private func _getSpriteFromPool() -> SKSpriteNode? {
        if var s = _pool.getElement() as? SKSpriteNode {
            s.position = CGPoint(
                x: CGFloat(MZ.Maths.randomFloat(min: 0.0, max: scene.size.width.toMZFloat())),
                y: CGFloat(MZ.Maths.randomFloat(min: 0.0, max: scene.size.height.toMZFloat()))
            )

            s.setScale(CGFloat(MZ.Maths.randomFloat(min: 0.5, max: 2)))
            s.zRotation = CGFloat(MZ.Maths.randomFloat(min: 0.0, max: (2.0 * M_PI)))

            _usingSprites.append(s)
            
            return s
        }

        return nil
    }

    private func _randomReturnElementsToPool() {
        if _usingSprites.count == 0 { return }

        let count = MZ.Maths.randomInt(1..._usingSprites.count)

        println("return \(count)")

        for i in 1...count {
            let removeIndex = MZ.Maths.randomInt(0..<_usingSprites.count)
            _usingSprites[removeIndex].returnToPool()
            _usingSprites.removeAtIndex(removeIndex)
        }

        _testActionInvoke = _randomGetElementsFromPool
    }

    private func _randomGetElementsFromPool() {
        let count = MZ.Maths.randomInt(1..._pool.totalElements) / 2

        println("try to get \(count)")

        for i in 0..<count { _getSpriteFromPool() }

        _testActionInvoke = _randomReturnElementsToPool
    }
}