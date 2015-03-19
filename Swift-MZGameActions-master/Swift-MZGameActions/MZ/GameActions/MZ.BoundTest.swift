import Foundation
import CoreGraphics

extension MZ {

    public class BoundTest : Action {

        public typealias OutOfBoundAction = ((boundTest: BoundTest, tester: MZPTransform)->())?

        public var bound: CGRect

        public weak var tester: MZPTransform!

        public var testerSize: CGSize

        public var outOfBoundAction: OutOfBoundAction

        private (set) var isInBound: Bool = true

        init(
            tester: MZPTransform,
            testerSize: CGSize = CGSize.one,
            bound: CGRect,
            outOfBoundAction: OutOfBoundAction? = nil
        ) {
            self.tester = tester
            self.bound = bound
            self.testerSize = testerSize
            self.outOfBoundAction = outOfBoundAction?
        }

        override public func update() {
            super.update()

            isInBound = !_isOutOfBound()
            if !isInBound { outOfBoundAction?(boundTest: self, tester: tester) }
        }



        // MARK: Private

        deinit {
            tester = nil
        }

        private func _isOutOfBound() -> Bool {
            var testerRect = CGRect(x: 0, y: 0, width: testerSize.width, height: testerSize.height)
            testerRect.center = tester.position

            return !CGRectIntersectsRect(bound, testerRect)
        }
    }
}