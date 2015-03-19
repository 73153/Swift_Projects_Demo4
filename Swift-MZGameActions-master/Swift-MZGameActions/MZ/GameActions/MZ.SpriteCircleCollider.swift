import Foundation
import SpriteKit

extension MZ {

    public class SpriteCircleCollider : Action {

        public class func isCollid(#colliderA: SpriteCircleCollider, colliderB: SpriteCircleCollider) -> Bool {
            let distancePow2 = MZ.Maths.distancePow2(p1: colliderA.position, p2: colliderB.position)
            let collidedDistancePow2 = pow(colliderA.radius + colliderB.radius, 2).toCGFloat()

            return distancePow2 <= collidedDistancePow2
        }

        public weak var sprite: SKSpriteNode!

        public var offset: CGPoint = CGPoint.zero

        public var collisionScale: MZFloat = 1

        public var collidedAction: ((SpriteCircleCollider, SpriteCircleCollider) -> ())? = nil

        public var originRadius: MZFloat {
            get {
                let maxSize = fmax(sprite.size.width, sprite.size.height).toMZFloat() / 2
                return maxSize
            }
        }

        public var radius: MZFloat { get { return collisionScale * originRadius } }

        public var position: CGPoint {
            get {
                let scaleOffset = CGPoint(x: offset.x * sprite.xScale, y: offset.y * sprite.yScale)
                let radians = sprite.zRotation
                let resultOffset = MZ.Maths.vectorMapToRadians(vector: scaleOffset, mapToRadians: radians.toMZFloat())

                return self.sprite.position + resultOffset
            }
        }

        init(sprite: SKSpriteNode, offset: CGPoint = CGPoint.zero, collisionScale: MZFloat = 1) {
            self.sprite = sprite
            self.offset = offset
            self.collisionScale = collisionScale
        }

        public func isCollidesWithAnother(another: SpriteCircleCollider) -> Bool {
            if SpriteCircleCollider.isCollid(colliderA: self, colliderB: another) {
                // TODO: is this design fine????
                self.collidedAction?(self, another)
                another.collidedAction?(another, self)

                return true
            }

            return false
        }
    }
}