import Foundation

extension MZ {

    @objc public class Wait: Action {

        public override var isActive: Bool { get { return self.passedTime < self.duration } }

        init(wait: MZFloat) {
            super.init()
            self.duration = wait
        }
    }
}
