// TODO: protocol 裡不要有 class? 有必要嗎?

import Foundation
import CoreGraphics

// MARK: MZPAction

public protocol MZPAction {
    var duration: MZFloat? { set get }
    var timeScale: MZFloat { set get }

    var isActive: Bool { get }
    var deltaTime: MZFloat { get }
    var passedTime: MZFloat { get }

    func start()
    func update()
    func didFinishUpdate()
    func end()
}

// MARK: MZPTransform

@objc public protocol MZPTransform {
    var position: CGPoint { get set }
    var scaleXY: CGPoint { get set }
    var scale: MZFloat  { get set }
    var rotation: MZFloat { get set }
}


// MARK: MZActionsContainer

public protocol MZActionsContainer {
    func addAction<T: MZ.Action>(action: T, settingAction: ((T)->())?) -> T

    func removeAction(action: MZ.Action)
    func removeInactiveActions()
    func removeAllActions()
}