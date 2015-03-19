import Foundation

extension MZ.Moves {

    public class TurnFromTo : Base {

        public class func degreesOutOfBoundFixWithDegree(
            degrees: MZFloat,
            limitedDegrees: MZFloat,
            increaseSign: Int
        ) -> MZFloat {
            if increaseSign > 0 {
                let modifyLimitedDeg = degrees > limitedDegrees ? limitedDegrees + 360 : limitedDegrees
                if degrees > modifyLimitedDeg { return limitedDegrees }
            } else if increaseSign < 0 {
                let modifyLimitedDeg = degrees < limitedDegrees ? limitedDegrees - 360 : limitedDegrees;
                if degrees < modifyLimitedDeg { return limitedDegrees }
            }

            return degrees;
        }

        public override var actionTime: MZ.ActionTime {
            get { return _moveWithVelocityDirection.actionTime }
            set { _moveWithVelocityDirection.actionTime = newValue  }
        }

        public var permissibleDegreesRange: MZFloat = 3 // 防止抖動, 預設 3 ... 需要更好的方

        public var acceleration: MZFloat {
            get { return _moveWithVelocityDirection.acceleration }
            set { _moveWithVelocityDirection.acceleration = newValue }
        }

        public var velocityLimited: MZFloat? {
            get { return _moveWithVelocityDirection.velocityLimited }
            set { _moveWithVelocityDirection.velocityLimited = newValue }
        }

        public override var currentDirection: MZFloat {
            get { return _moveWithVelocityDirection.currentDirection }
        }

        init(mover: MZPTransform, from: MZFloat, to: MZFloat, degreesVelocity: MZFloat, velocity: MZFloat) {
            MZ.assert(
                degreesVelocity >= 0,
                "turnDegreesPerSecond must more than zero, but is %0.2f",
                degreesVelocity
            )

            self._from            = from
            self._to              = to
            self._degreesVelocity = degreesVelocity
            self._velocity        = velocity

            _moveWithVelocityDirection = VelocityDirection(mover: mover)
            super.init(mover: mover)
        }

        public override func start() {
            super.start()

            _moveWithVelocityDirection.direction = _from
            _moveWithVelocityDirection.velocity  = _velocity
            _moveWithVelocityDirection.start()
        }

        public override func end() {
            super.end()
            _moveWithVelocityDirection.end()
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            _moveWithVelocityDirection.direction = _nextDirection()
            _moveWithVelocityDirection.updateWhenActive()
        }



        // MARK: Private

        private var _from: MZFloat

        private var _to: MZFloat

        private var _degreesVelocity: MZFloat

        private var _velocity: MZFloat

        private var _moveWithVelocityDirection : VelocityDirection

        private func _nextDirection() -> MZFloat {
            let currDeg = MZ.Maths.formatDegrees(currentDirection)
            let toDeg   = MZ.Maths.formatDegrees(_to)

            if abs(currDeg - toDeg) <= permissibleDegreesRange {
                return toDeg
            }

            let shortestDistance = MZ.Maths.shortestDistanceFromDegrees(currDeg, toDegrees: toDeg)

            let increaseSign = shortestDistance >= 0 ? 1 : -1
            let deltaDeg = MZFloat(increaseSign) * (_degreesVelocity * deltaTime)
            var nextDeg = MZ.Maths.formatDegrees(currDeg + deltaDeg)

            nextDeg = TurnFromTo.degreesOutOfBoundFixWithDegree(nextDeg,
                limitedDegrees: toDeg,
                increaseSign: increaseSign
            )

            return MZ.Maths.formatDegrees(nextDeg)
        }
    }
}