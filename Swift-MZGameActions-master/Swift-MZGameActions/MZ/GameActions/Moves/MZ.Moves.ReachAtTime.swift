import Foundation
import CoreGraphics

extension MZ.Moves {

    public class ReachAtTime : Base {

        public override var isActive: Bool { get { return passedTime <= duration } }

        public override var currentDirection: MZFloat { get { return _direction } }

        init(mover: MZPTransform, start: CGPoint? = nil, destination: CGPoint, duration: MZFloat) {
            self._start       = start
            self._destination = destination

            super.init(mover: mover)

            self.duration = duration
        }

        public override func start() {
            super.start()

            if _start != nil {
                 mover.position = _start!
            } else {
                _start = mover.position
            }

            _direction = MZ.Maths.degressFromP1(_start!, toP2: _destination)
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            let lerp = MZ.Maths.lerp(numerator: passedTime, denominator: duration!)

            if lerp == 1.0 {
                mover.position = _destination
            } else {
                let diff = _destination - _start!
                mover.position = _start! + (diff * lerp.toCGFloat())
            }
        }



        // MARK: Private

        private var _start: CGPoint?

        private var _destination: CGPoint!

        private var _direction: MZFloat!
    }
}
