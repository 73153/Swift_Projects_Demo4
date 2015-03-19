import Foundation
import CoreGraphics

extension MZ.Moves {

    public class Follow : Base {

        public var velocity : MZFloat {
            get { return _moveWithVelocityDirection.velocity }
            set { _moveWithVelocityDirection.velocity = newValue }
        }

        public override var actionTime: MZ.ActionTime {
            get { return _moveWithVelocityDirection.actionTime }
            set { _moveWithVelocityDirection.actionTime = newValue }
        }

        public override var currentDirection: MZFloat {
            get { return _moveWithVelocityDirection.currentDirection }
        }

        init(mover: MZPTransform, targetFunc: ()->(CGPoint?)) {
            self._targetFunc = targetFunc

            super.init(mover: mover)

            self._moveWithVelocityDirection = VelocityDirection(mover: mover)
        }

        public override func start() {
            super.start()
            _moveWithVelocityDirection.start()
        }

        public override func end() {
            super.end()
            _moveWithVelocityDirection.end()
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            let tarPos = _targetFunc()
            if tarPos != nil {
                let tarDir = MZ.Maths.degreesFromXAxisToVector(tarPos! - mover.position)
                _moveWithVelocityDirection.direction = tarDir
            }

            _moveWithVelocityDirection.updateWhenActive()
        }



        // MARK: Private

        private var _targetFunc: ()->(CGPoint?)

        private var _moveWithVelocityDirection: VelocityDirection!
    }
}
