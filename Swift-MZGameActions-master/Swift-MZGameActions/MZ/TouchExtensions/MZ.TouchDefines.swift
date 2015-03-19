import Foundation
import UIKit

@objc public protocol MZPTouchNotifier {
    func addTouchResponder(touchResponder: AnyObject)
    func removeTouchResponder(touchResponder: AnyObject)

    optional func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    optional func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    optional func touchesEnded(touches: NSSet, withEvent event: UIEvent)

    func positionWithTouch(touch: UITouch) -> CGPoint
}

@objc public protocol MZPTouchResponder {

    weak var touchNotifier: MZPTouchNotifier? { get set }

    func touchesBegan(touches: NSSet)
    func touchesMoved(touches: NSSet)
    func touchesEnded(touches: NSSet)

    func removeFromNotifier()
}

extension MZ {

    public enum TouchType {
        case Began, Moved, Ended

        func toString() -> String {
            switch self {
            case .Began: return "MZ.TouchType.Began"
            case .Moved: return "MZ.TouchType.Moved"
            case .Ended: return "MZ.TouchType.Ended"
            }
        }
    }
}