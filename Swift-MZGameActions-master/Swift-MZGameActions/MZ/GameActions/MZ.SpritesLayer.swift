import Foundation
import SpriteKit

extension MZ {

    @objc public class SpritesLayer: SKNode {

        // FIXME: extended SKNode bug, rm optional
        private(set) var spritesPool: Pool? = nil

        private(set) var numberOfSprites: Int = 0

        public var animationActionNames: [String] {
            get {
                var names = [String]()
                for (an, _) in _animationsActionsDict { names.append(an) }
                return names
            }
        }

        // FIXME: extended SKNode bug
        // if apple fix, remvoe pool optional
        public required init(coder aDecoder: NSCoder) {
            MZ.assertAlwayFalse("extended SKNode bug? do't use me")
            super.init()
        }

        init(altas: SKTextureAtlas, numberOfSprites: Int) {
            super.init()

            self.numberOfSprites = numberOfSprites
            _altas = altas

            let firstTexture = _altas!.textureNamed(_altas!.textureNames.first! as String)

            var spriteGenFunc: () -> SKSpriteNode = {
                var sprite = SKSpriteNode(texture: firstTexture)
                self.addChild(sprite)
                sprite.hidden = true

                return sprite
            }

            spritesPool = Pool(
                numberOfElements: numberOfSprites,
                elementGenFunc: spriteGenFunc,
                getAction: _getFromPoolAction,
                returnAction: _returnToPoolAction
            )
        }

        public func textureWithName(name: String) -> SKTexture {
            return _altas!.textureNamed(name)
        }

        public func spriteWithTexture(#textureName: String) -> SKSpriteNode {
            var texture = textureWithName(textureName)

            var sprite = _getSpriteFromPool()

            sprite.size = texture.size()
            sprite.texture = texture;

            return sprite
        }

        // MARK: get sprite with animation

        public func addAnimation(#name: String, textureNames: [String], oneLoopTime: MZFloat) {
            var textures = [AnyObject]()
            for tname in textureNames { textures.append(textureWithName(tname)) }
            let interval: Double = oneLoopTime / Double(textureNames.count)

            if textures.count == 0 { return }

            var aniAction = SKAction.animateWithTextures(
                textures,
                timePerFrame: interval,
                resize: true,
                restore: false
            )

            _animationsActionsDict[name] = aniAction
            _animatiomNameToFirstTexture[name] = textures.first as? SKTexture
        }

        public func animationActionWithName(name: String) -> SKAction {
            return _animationsActionsDict[name]!
        }

        public func spriteWithAnimation(#animationName: String) -> SKSpriteNode {
            var sprite = _getSpriteFromPool()
            sprite.runAction(animationActionWithName(animationName))

            return sprite
        }

        public func spriteWithRepeatsAnimation(#animationName: String, repeatTimes: Int) -> SKSpriteNode {
            var sprite = _getSpriteFromPool()
            var repeatsAction = SKAction.repeatAction(animationActionWithName(animationName), count: repeatTimes)
            sprite.runAction(repeatsAction)
            sprite.size = animationFirstTextureWithName(animationName)!.size()

            return sprite
        }

        public func spriteWithForeverAnimation(#animationName: String) -> SKSpriteNode {
            var sprite = _getSpriteFromPool()
            var repeatsAction = SKAction.repeatActionForever(animationActionWithName(animationName))
            sprite.runAction(repeatsAction)
            sprite.size = animationFirstTextureWithName(animationName)!.size()

            return sprite
        }

        public func animationFirstTextureWithName(name: String) -> SKTexture? {
            return _animatiomNameToFirstTexture[name]
        }



        // MARK: Private

        private var _altas: SKTextureAtlas? = nil

        private var _animationsActionsDict = [String: SKAction]()

        private var _animatiomNameToFirstTexture = [String: SKTexture]()

        deinit {
            spritesPool!.clear()
            _altas = nil
        }

        private func _getFromPoolAction(spritePE: MZPoolElement) {
            var sprite = spritePE as SKSpriteNode
            sprite.hidden = false
            sprite.setScale(1)
            sprite.color = SKColor.whiteColor()
        }

        private func _returnToPoolAction(spritePE: MZPoolElement) {
            var sprite = spritePE as SKSpriteNode
            sprite.hidden = true
            sprite.physicsBody = nil
        }

        private func _getSpriteFromPool() -> SKSpriteNode {
            var sprite = spritesPool!.getElement() as SKSpriteNode?
            assert(sprite != nil, "pool is not enough")

            return sprite!
        }
    }
}
