import Foundation
import SpriteKit

// MARK: MZUserData

extension SKNode {

    public var mzUserData: NSMutableDictionary {
        get {
            if self.userData == nil { self.userData = NSMutableDictionary() }
            return self.userData!
        }
    }
}

extension SKNode : MZPTransform {
    
    public var scaleXY: CGPoint {
        get { return CGPoint(x: self.xScale, y: self.yScale) }
        set { self.xScale = newValue.x; self.yScale = newValue.y }
    }

    public var scale: MZFloat  {
        get { return self.xScale.toMZFloat() }
        set { self.xScale = newValue.toCGFloat(); self.yScale = newValue.toCGFloat() }
    }

    public var rotation: MZFloat {
        get { return MZ.Maths.degreesFromRadians(self.zRotation.toMZFloat())  }
        set { self.zRotation = MZ.Maths.radiansFromDegrees(newValue).toCGFloat() }
    }
}

// MARK: MZTouch

extension SKNode {
    
    public typealias MZTouchAction = (sender: AnyObject, touches: NSSet, event: UIEvent) -> ()

    @objc class _TouchActionContainer {
        var action: MZTouchAction
        init(action: MZTouchAction) { self.action = action }
    }

    public func addTouch(#type: MZ.TouchType, touchAction: MZTouchAction) {
        self.userInteractionEnabled = true
        self.mzUserData[type.toString()] = _TouchActionContainer(touchAction)
    }

    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        _runAction(touchType: MZ.TouchType.Began, sender: self, touches: touches, event: event)
    }

    override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        _runAction(touchType: MZ.TouchType.Moved, sender: self, touches: touches, event: event)
    }

    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        _runAction(touchType: MZ.TouchType.Ended, sender: self, touches: touches, event: event)
    }


    // MARK: Private

    func _runAction(#touchType: MZ.TouchType, sender: AnyObject, touches: NSSet, event: UIEvent) {
        if self.mzUserData[touchType.toString()] == nil { return } // issue: enum can not be dict key

        let touchAction: _TouchActionContainer = self.mzUserData[touchType.toString()] as _TouchActionContainer
        touchAction.action(sender: sender, touches: touches, event: event)
    }
}

// MARK: MZPoolElement

extension SKNode : MZPoolElement {

    public var pool: MZ.Pool? {
        get { return self.mzUserData["pool"] == nil ? nil : self.mzUserData["pool"] as? MZ.Pool }
        set { self.mzUserData["pool"] = newValue }
    }

    public var poolElementIndex: Int {
        get { return self.mzUserData["poolElementIndex"] as Int }
        set { self.mzUserData["poolElementIndex"] = newValue }
    }

    public func returnToPool() {
        pool?.returnElement(self)
    }

    public func remove() {
        if pool != nil { returnToPool() }
        else { removeFromParent() }
    }
}