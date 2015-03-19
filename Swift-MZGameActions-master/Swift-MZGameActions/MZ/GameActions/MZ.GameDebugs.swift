import Foundation
import SpriteKit

extension MZ {

    @objc public class GameDebugs {

        public class var instance : GameDebugs {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var _instance : GameDebugs? = nil
            }
            dispatch_once(&Static.onceToken) {
                Static._instance = GameDebugs()
            }
            return Static._instance!
        }

        public var debug: Bool = false

        public class func drawCircleColliderWithActor(
            actor: MZ.Actor,
            toParent parent: SKNode,
            color: SKColor = SKColor.greenColor()
        ) {
            if !instance.debug { return }

            let colliders = actor.actionsWithClass(MZ.SpriteCircleCollider.self) as [MZ.SpriteCircleCollider]

            for collider in colliders {
                var circle = SKShapeNode(circleOfRadius: collider.radius.toCGFloat())
                parent.addChild(circle)

                circle.fillColor = color
                circle.position = collider.position
            }
        }

        public class func drawColliderWithNode(node: SKNode, parent: SKNode, color: SKColor = SKColor.whiteColor()) {
            if !instance.debug { return }

            if node.hidden { return }
            if node.physicsBody == nil { return }
            if node.mzUserData[PhysicsBody.actionName()] == nil { return }

            let mzBody = node.mzUserData[PhysicsBody.actionName()]! as PhysicsBody
            if mzBody.bodyType == PhysicsBody.BodyType.Path { return }

            var debugDrawSprite: SKShapeNode?
            if mzBody.bodyType == PhysicsBody.BodyType.Circle {
                debugDrawSprite = SKShapeNode(circleOfRadius: mzBody.circleOfRadius!)
            } else {
                debugDrawSprite = SKShapeNode(rectOfSize: mzBody.rectangleOfSize!)
            }

            if debugDrawSprite == nil { return }

            debugDrawSprite!.strokeColor = color
            debugDrawSprite!.position = node.position
            parent.addChild(debugDrawSprite!)
        }
    }
}
