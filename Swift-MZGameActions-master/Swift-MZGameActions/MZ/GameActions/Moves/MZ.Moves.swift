import Foundation

extension MZ {
    public class Moves {}
}

extension MZ.Moves {

    public class Base : MZ.Action {

        public weak var mover: MZPTransform!

        public var currentDirection: MZFloat { get { MZ.assertOverrideMe(); return 0 } }

        init(mover: MZPTransform) {
            super.init()
            self.mover = mover
        }

        deinit {
            mover = nil
        }
    }
}

