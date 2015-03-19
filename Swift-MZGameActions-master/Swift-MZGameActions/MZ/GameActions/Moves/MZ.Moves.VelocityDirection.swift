import Foundation

extension MZ.Moves {

    public class VelocityDirection : Base {

        public var velocity : MZFloat = 0

        public var direction : MZFloat = 0

        public var acceleration : MZFloat = 0

        public var velocityLimited : MZFloat? = nil

        public override var currentDirection : MZFloat { get { return direction } }

        public override func updateWhenActive() {
            super.updateWhenActive()

            var currVelocity = velocity + acceleration * self.passedTime;

            if velocityLimited != nil {
                if acceleration > 0 { currVelocity = min(currVelocity, self.velocityLimited!) }
                if acceleration < 0 { currVelocity = max(currVelocity, self.velocityLimited!) }
            }

            var deltaMovement = currVelocity * self.deltaTime
            var uv = MZ.Maths.unitVectorFromDegrees(direction)

            var deltaMovementXY = uv * deltaMovement.toCGFloat()
            mover?.position += deltaMovementXY
        }

    }
}
