import Foundation
import SpriteKit

extension MZ {

    // TODO: 
    // contact callback ...
    // support offset if center has value

    @objc public class PhysicsBody : Action {

//        public class let actionName: String = "MZPhysicsBody" // not support class property yet :D
        public class func actionName() -> String { return "MZPhysicsBody" }

        public enum BodyType {
            case Path
            case Circle
            case Rectangle
        }

        public weak var node: SKNode!

        public var bodiesContactAction: ((selfBody: SKPhysicsBody, otherBody: SKPhysicsBody) -> ())? = nil

        public var physicsBody: SKPhysicsBody { get { return node.physicsBody! } }

        private (set) var bodyType: BodyType = BodyType.Path

        public var circleOfRadius: CGFloat? { get { return _originCircleOfRadius! * node.scale.toCGFloat() } }

        public var rectangleOfSize: CGSize? { get { return _originRectangleOfSize! * node.scale.toCGFloat() } }

        init(node: SKNode, physicsBody: SKPhysicsBody) {
            super.init()
            self.node = node
            self.node.physicsBody = physicsBody
            self.node.mzUserData[PhysicsBody.actionName()] = self
        }

        convenience init(node: SKNode, texture: SKTexture, size: CGSize) {
            var pb = SKPhysicsBody(texture: texture, size: size)

            self.init(node: node, physicsBody: pb)
        }

        convenience init(node: SKNode, circleOfRadius: CGFloat, center: CGPoint = CGPoint.zero) {
            var pb = SKPhysicsBody(circleOfRadius: circleOfRadius, center: center)

            self.init(node: node, physicsBody: pb)
            self.bodyType = BodyType.Circle
            _originCircleOfRadius = circleOfRadius
        }

        convenience init(node: SKNode, rectangleOfSize: CGSize, center: CGPoint = CGPoint.zero) {
            var pb = SKPhysicsBody(rectangleOfSize: rectangleOfSize, center: center)

            self.init(node: node, physicsBody: pb)
            self.bodyType = BodyType.Rectangle
            _originRectangleOfSize = rectangleOfSize
        }



        // MARK: Private

        private var _originCircleOfRadius: CGFloat?

        private var _originRectangleOfSize: CGSize?

        private var _originCenter: CGPoint?
    }
}
