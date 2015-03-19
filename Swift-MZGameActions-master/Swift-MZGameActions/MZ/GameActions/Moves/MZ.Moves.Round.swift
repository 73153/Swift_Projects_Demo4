import Foundation
import CoreGraphics

extension MZ.Moves {

    public class Round : Base {

        public var degreesVelocity: MZFloat = 0

        public override var currentDirection: MZFloat {
            get { return _currentTheta + (degreesVelocity >= 0 ? 90 : -90) }
        }

        init(mover: MZPTransform, centerFunc: ()->(CGPoint?)) {
            self._centerFunc = centerFunc
            super.init(mover: mover)
        }

        public override func start() {
            super.start()

            let center = _centerFunc()
            if center == nil { return }

            _currentRadius = MZ.Maths.distance(p1: mover.position, p2: center!).toMZFloat()

            let vector = MZ.Maths.unitVectorFromPoint1(center!, toPoint2: mover.position)
            _currentTheta = MZ.Maths.degreesFromXAxisToVector(vector)
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            var center = _centerFunc()
            if center == nil { return }

            _currentTheta += degreesVelocity * deltaTime

            let currentThetaRadians = MZ.Maths.radiansFromDegrees(_currentTheta).toCGFloat()

            let x = center!.x + _currentRadius.toCGFloat() * cos(currentThetaRadians)
            let y = center!.y + _currentRadius.toCGFloat() * sin(currentThetaRadians)

            mover.position = CGPoint(x: x, y: y)
        }



        // MARK: Private

        private var _centerFunc: ()->(CGPoint?)

        private var _currentRadius: MZFloat = 0

        private var _currentTheta: MZFloat = 0
    }
}
