import Foundation
import SpriteKit

@objc public protocol MZPQueueActionElemnt {
    var scene: SKScene! { get set }
    var title: String! { get }
    var description: String! { get }
    var isDone: Bool { get }

    func start()
    func update(currentTime: NSTimeInterval)
    optional func didFinishUpdate()
    optional func end()

    optional func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    optional func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    optional func touchesEnded(touches: NSSet, withEvent event: UIEvent)
}

//public var scene: SKScene!
//public var title: String! = ""
//public var description: String! = ""
//public var isDone: Bool { get { return false } }
//init() {}
//public func start() {}
//public func update(currentTime: NSTimeInterval) {}
//public func end() {}

extension MZ {

    public class SceneWithQueue: SKScene {

        private(set) var currentActionElement: MZPQueueActionElemnt? = nil

        public override func didMoveToView(view: SKView) {
        }

        public func push(queueElemnt: MZPQueueActionElemnt) {
            _actionElementsQueue.append(queueElemnt)
        }

        public override func update(currentTime: NSTimeInterval) {
            checkActionsDone()
            _popActionIfNil()
            currentActionElement?.update(currentTime)
            _checkActionEnd()
        }

        public override func didFinishUpdate() {
            currentActionElement?.didFinishUpdate?()
        }

        private func checkActionsDone() {
            if currentActionElement != nil || _actionElementsQueue.count > 0 || _isAllActionsDone == true { return }
            _isAllActionsDone = true
            println("\\>/////////</ ... All Actions are Done ... \\>/////////</")
        }

        public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            if currentActionElement == nil { return }

            if let touchNotifier = currentActionElement as? MZPTouchNotifier {
                touchNotifier.touchesBegan?(touches, withEvent: event)
            } else {
                currentActionElement!.touchesBegan?(touches, withEvent: event)
            }
        }

        public override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            if currentActionElement == nil { return }

            if let touchNotifier = currentActionElement as? MZPTouchNotifier {
                touchNotifier.touchesMoved?(touches, withEvent: event)
            } else {
                currentActionElement!.touchesMoved?(touches, withEvent: event)
            }
        }

        public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            if currentActionElement == nil { return }

            if let touchNotifier = currentActionElement as? MZPTouchNotifier {
                touchNotifier.touchesEnded?(touches, withEvent: event)
            } else {
                currentActionElement!.touchesEnded?(touches, withEvent: event)
            }
        }


        // MARK: Private

        private var _actionElementsQueue: [MZPQueueActionElemnt] = [MZPQueueActionElemnt]()

        private var _isAllActionsDone: Bool = false

        private func _popActionIfNil() {
            if _actionElementsQueue.count == 0 || currentActionElement != nil { return }

            currentActionElement = _actionElementsQueue.first

            println("=== Action '\(currentActionElement!.title)' is begin ===")
            println("Description: \(currentActionElement!.description)")

            currentActionElement!.scene = self
            currentActionElement!.start()

            _actionElementsQueue.removeAtIndex(0)
        }
        
        private func _checkActionEnd() {
            if currentActionElement == nil { return }
            if !currentActionElement!.isDone { return }
            
            currentActionElement!.end?()
            
            println("=== Test case '\(currentActionElement!.title)' end ===\n")
            
            currentActionElement = nil
        }
    }
}