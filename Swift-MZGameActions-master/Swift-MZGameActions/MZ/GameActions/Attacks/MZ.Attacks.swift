import Foundation
import CoreGraphics

extension MZ {
    public class Attacks {}
}

extension MZ.Attacks {

    public class Base : MZ.Action {

        public weak var attacker: MZPTransform!

        public var colddown: MZFloat = 0

        public var bulletVelocity: MZFloat = 0

        public var bulletGenFunc: (() -> MZ.Actor?)? = nil

        public var launchCount: Int = 0

        public var offset: CGPoint?

        public var bulletScaleXY: CGPoint = CGPoint.one;

        public var bulletScale: CGFloat {
            get { assert(bulletScaleXY.x == bulletScaleXY.y, "x != y"); return bulletScaleXY.x }
            set { bulletScaleXY = CGPoint(x: newValue, y: newValue) }
        }

        private (set) var currentLanchedCount: Int = 0 // TODO:

        private (set) var currentBulletLanchedCount: Int = 0 // TODO:

        init(attacker: MZPTransform) {
            self.attacker = attacker
        }

        public func bulletWithAppliedSetting() -> MZ.Actor? {
            var b = bulletGenFunc?();

            if b == nil { return nil }

            b!.scaleXY = self.bulletScaleXY

            var move1 =
                b!.addActionWithName("move1", action: MZ.Moves.VelocityDirection(mover: b!))
                as MZ.Moves.VelocityDirection

            move1.velocity = self.bulletVelocity

            var realOffset = offset != nil ? offset! : CGPoint.zero
            realOffset = CGPoint(
                x: realOffset.x * attacker.scaleXY.x,
                y: realOffset.y * attacker.scaleXY.y
            )

            realOffset = MZ.Maths.vectorMapToDegrees(vector: realOffset, degrees: attacker.rotation)

            b!.position = attacker!.position + realOffset;

            return b;
        }



        // MARK: Private

        deinit {
            attacker = nil
        }
    }
}