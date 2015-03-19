import Foundation
import CoreGraphics

extension MZ.Moves {

    public class TurnFromToInDuration : Base {

        public override var actionTime: MZ.ActionTime {
            get { return _moveWithVelocityDirection.actionTime }
            set { _moveWithVelocityDirection.actionTime = newValue }
        }

        public var velocity: MZFloat {
            get { return _moveWithVelocityDirection.velocity }
            set { _moveWithVelocityDirection.velocity = newValue }
        }

        public override var isActive: Bool {
            get { return passedTime < duration }
        }

        public override var currentDirection: MZFloat {
            get { return _moveWithVelocityDirection.currentDirection }
        }

        init(mover: MZPTransform, from: MZFloat, to: MZFloat, duration: MZFloat) {
            self._from = from
            self._to   = to
            self._moveWithVelocityDirection = VelocityDirection(mover: mover)

            super.init(mover: mover)

            self.duration = duration
        }

        public override func start() {
            super.start()

            _degreesDistance = MZ.Maths.shortestDistanceFromDegrees(_from, toDegrees: _to)

            _moveWithVelocityDirection.start()
        }

        public override func end() {
            super.end()
            _moveWithVelocityDirection.end()
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            let lerp = MZ.Maths.lerp(numerator: passedTime, denominator: duration!)

            if lerp == 1 {
                mover.rotation = _to
                return
            }

            _moveWithVelocityDirection.direction = _from + (_degreesDistance * lerp)
            _moveWithVelocityDirection.updateWhenActive()
        }



        // MARK: Private

        private var _moveWithVelocityDirection: VelocityDirection

        private var _from: MZFloat

        private var _to: MZFloat

        private var _degreesDistance: MZFloat = 0
    }
}
