import Foundation
import SpriteKit

public class TestIOS8SK_LightNode : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = "測試 iOS 8 的 SKLightNode"

    public var description: String! = "LightNode = 點光源"

    public var isDone: Bool { get { return false } }

    init() {}

    public func start() {
        scene.addChild(_testLayer)

//        _setBackground()
//        _setCharacters()
//        _setLights()

        let w = 128
        let h = 128

        var pixels = [UInt32]()

//        for i in 0..<(w*h) {
            pixels.append(0x00ff00)
//        }

        for i in 1..<w*h {
            pixels.append(0x0000ff)
        }

        var data = NSData(bytes: pixels, length: w*h*sizeof(UInt32))

        var t = SKTexture(data: data, size: CGSize(width: w, height: h))
        t.filteringMode = SKTextureFilteringMode.Nearest

        var s = SKSpriteNode(texture: t)
        _testLayer.addChild(s)
        s.position = CGPoint(size: scene.size / 2)
        s.scale = 2
    }

    public func update(currentTime: NSTimeInterval) {}
    
    public func end() {}



    // MARK: Private

    private var _testLayer = SKNode()

    private func _setBackground() {
        var bg = SKSpriteNode(color: SKColor.whiteColor(), size: scene.size)
        bg.anchorPoint = CGPoint.zero
        _testLayer.addChild(bg)
    }

    private func _setCharacters() {
        func newCharacter(#imageNamed: String, #at: CGPoint, #lightingBitMask: UInt32) -> SKSpriteNode {
            var c = SKSpriteNode(imageNamed: imageNamed)
            c.normalTexture = c.texture!.textureByGeneratingNormalMap()

            _testLayer.addChild(c)
            c.position = at

            c.lightingBitMask = lightingBitMask
//            c.shadowCastBitMask = lightingBitMask // super lagyyyyy :D

            return c
        }

        let center = CGPoint(size: scene.size / 2)

        let textureNames = ["C001_redhoodie_thum", "C003_rabbit_thum", "C005_deer_thum"]
        let positions = [center + CGPoint(x: -100, y: -100), center, center + CGPoint(x: 100, y: -100)]

        for i in 0..<textureNames.count {
            newCharacter(imageNamed: textureNames[i], at: positions[i], lightingBitMask: UInt32(1 << i))
        }
    }

    private func _setLights() {
        let center = CGPoint(size: scene.size / 2)

        func newLight(
            #text: String,
            #color: SKColor,
            #categoryBitMask: UInt32,
            #start: CGPoint,
            #action: SKAction
        ) -> SKNode {
            var node = SKNode()
            _testLayer.addChild(node)

            var label = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
            label.text = "[" + text + "]"
            label.fontColor = color
            label.scale = 0.5
            node.addChild(label)

            var light = SKLightNode()
            node.addChild(light)
            light.categoryBitMask = categoryBitMask
            light.lightColor = color

            node.position = start

            node.runAction(action)

            return node
        }

        newLight(
            text: "R for one",
            color: SKColor.redColor(),
            categoryBitMask: 1 << 1,
            start: center + CGPoint(x: -center.x, y: 100),
            action: SKAction.repeatActionForever(SKAction.sequence([
                SKAction.moveToX(scene.size.width, duration: 1),
                SKAction.moveToX(0, duration: 1)
            ]))
        )

        newLight(
            text: "G for one",
            color: SKColor.greenColor(),
            categoryBitMask: 1 << 2,
            start: CGPoint(x: scene.size.width, y: 0),
            action: SKAction.repeatActionForever(SKAction.sequence([
                SKAction.moveToY(scene.size.height, duration: 1),
                SKAction.moveToY(0, duration: 1)
            ]))
        )

        newLight(
            text: "B for ALL",
            color: SKColor.blueColor(),
            categoryBitMask: 1 << 0 | 1 << 1 | 1 << 2,
            start: CGPoint.zero + CGPoint(x: 0, y: 50),
            action: SKAction.repeatActionForever(SKAction.sequence([
                SKAction.moveToX(scene.size.width, duration: 1),
                SKAction.moveToX(0, duration: 1)
            ]))
        )
    }
}