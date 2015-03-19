import Foundation
import SpriteKit

public class Sample_SKTexture : MZPQueueActionElemnt {

    public var scene: SKScene!

    public var title: String! = ""

    public var description: String! = ""

    public var isDone: Bool { get { return false } }

    init() {}

    public func start() {
        _newTextureByCode()
        _newMutableTextureByCode()
        _setNoiseTexture()
    }

    public func update(currentTime: NSTimeInterval) {}

    public func end() {}



    // MARK: Private

    private func _newTextureByCode() {
        let w = 128
        let h = 128

        var pixels = [UInt32]()

        for i in 0..<(w * h) {
            let r = MZ.Maths.randomInt(0...255)
            let g = MZ.Maths.randomInt(0...255)
            let b = MZ.Maths.randomInt(0...255)

            let hex = UInt32(r << 16 + g << 8 + b)
            pixels.append(hex)
        }

        var data = NSData(bytes: pixels, length: sizeof(UInt32) * w * h)

        let texture = SKTexture(data: data, size: CGSize(width: w, height: h))

        let sprite = SKSpriteNode(texture: texture)
        scene.addChild(sprite)
        sprite.position = CGPoint(size: scene.size / 2) + CGPoint(x: 0, y: 200)
    }

    private func _newMutableTextureByCode() {
        let w = 64
        let h = 64

        var pixels = [UInt32]()

        for i in 0..<(w * h) {
            let r = 127
            let g = 0
            let b = 127

            let hex = UInt32(r << 16 + g << 8 + b)
            pixels.append(hex)
        }

        var data = NSData(bytes: pixels, length: sizeof(UInt32) * w * h)

        var texture = SKMutableTexture(size: CGSize(width: w, height: h))

        let r = 127
        let g = 0
        let b = 127
        let hex = UInt32(r << 16 + g << 8 + b)
        let tarPos = UInt(w / 2 + h / 2)

        texture.modifyPixelDataWithBlock({
            (bytes, len) in

            var d: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>(bytes)

            println(len / 4)

            for var i = 0; i < Int(len); i += 4 {
                d[i] = 10       // r
                d[i+1] = 127    // g
                d[i+2] = 127    // b
                d[i+3] = 255    // a
            }
        })
        
        let sprite = SKSpriteNode(texture: texture)
        scene.addChild(sprite)
        sprite.position = CGPoint(size: scene.size / 2) + CGPoint(x: 0, y: 0)
    }

    private func _setNoiseTexture() {
        var texture = SKTexture(vectorNoiseWithSmoothness: 0.5, size: CGSize(width: 64, height: 64))

        var sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPoint(size: scene.size / 2) + CGPoint(x: 0, y: -100)

        scene.addChild(sprite)
    }
}
