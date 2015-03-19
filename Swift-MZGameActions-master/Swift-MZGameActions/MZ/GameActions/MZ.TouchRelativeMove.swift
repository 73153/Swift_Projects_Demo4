import Foundation
import UIKit
import CoreGraphics

extension MZ {

    public class TouchRelativeMove : Action, MZPTouchResponder {

        public weak var mover: MZPTransform?

        public weak var touchNotifier: MZPTouchNotifier?

        public var bound : CGRect? = nil

        init(name: String? = "", mover: MZPTransform, touchNotifier: MZPTouchNotifier, bound: CGRect? = nil) {
            self.mover = mover
            self.touchNotifier = touchNotifier
            self.bound = bound

            super.init()

            if name != nil { self.name = name! }
            self.touchNotifier!.addTouchResponder(self)
        }

        deinit {
            removeFromNotifier()
            mover = nil
            touchNotifier = nil
        }

        public func touchesBegan(touches: NSSet) {
            if mover == nil || touchNotifier == nil { return }

            _moverPositionAtBegan = mover!.position
            _touchPositionAtBegan = touchNotifier!.positionWithTouch(touches.anyObject() as UITouch)
        }

        public func touchesMoved(touches: NSSet) {
            if _moverPositionAtBegan == nil || _touchPositionAtBegan == nil { return }

            let currTouchPos = touchNotifier!.positionWithTouch(touches.anyObject() as UITouch)
            let diff = currTouchPos - _touchPositionAtBegan!

            var nextPos = _moverPositionAtBegan! + diff;

            if let b = bound {
                var nextX = fmaxf(fminf(Float(nextPos.x), Float(CGRectGetMaxX(b))), Float(CGRectGetMinX(b)))
                var nextY = fmaxf(fminf(Float(nextPos.y), Float(CGRectGetMaxY(b))), Float(CGRectGetMinY(b)))

                nextPos = CGPoint(x: nextX, y: nextY)
            }

            mover!.position = nextPos;
        }

        public func touchesEnded(touches: NSSet) {
            _moverPositionAtBegan = nil
            _touchPositionAtBegan = nil
        }

        public func removeFromNotifier() {
            touchNotifier?.removeTouchResponder(self)
            touchNotifier = nil
        }



        // MARK: Private

        private var _moverPositionAtBegan: CGPoint? = nil

        private var _touchPositionAtBegan: CGPoint? = nil
    }
}
