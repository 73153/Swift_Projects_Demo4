import Foundation
import UIKit
import CoreGraphics

extension MZ {

    public class TouchTeleportMove: Action, MZPTouchResponder {

        public weak var mover: MZPTransform?

        public weak var touchNotifier: MZPTouchNotifier?

        public var bound : CGRect? = nil

        init(mover: MZPTransform, touchNotifier: MZPTouchNotifier, bound: CGRect? = nil) {
            self.mover = mover
            self.touchNotifier = touchNotifier
            self.bound = bound

            super.init()

            self.touchNotifier!.addTouchResponder(self)
        }

        public func touchesBegan(touches: NSSet) {
            let touchPosition = touchNotifier!.positionWithTouch(touches.anyObject() as UITouch)
            if !CGRectContainsPoint(bound!, touchPosition) { return }

            mover!.position = touchPosition
        }

        public func touchesMoved(touches: NSSet) {}

        public func touchesEnded(touches: NSSet) {}

        public func removeFromNotifier() {
            touchNotifier?.removeTouchResponder(self)
            touchNotifier = nil
        }
    }
}


