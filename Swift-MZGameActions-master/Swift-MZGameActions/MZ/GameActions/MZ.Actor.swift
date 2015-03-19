// TODO:
// action 用備份 dict cache 一下
// 移除部分, 可以直接呼叫 group 的即可, 不用自己也來一套啦 :D

import Foundation
import CoreGraphics

extension MZ {

    @objc public class Actor: Action, MZPTransform, MZActionsContainer {

        public override var isActive: Bool {
            get {
                for fn in _activeConditions { if !fn() { return false } }
                return true
            }
        }

        public override var actionTime: MZ.ActionTime {
            get { return _group.actionTime }
            set { _group.actionTime = newValue }
        }

        public var position: CGPoint {
            get { return _position }
            set {
                _position = newValue
                _updatePosition()
            }
        }
        private var _position: CGPoint = CGPoint.zero;

        public var scaleXY: CGPoint {
            get { return _scaleXY }
            set {
                _scaleXY = newValue
                _updateScale()
            }
        }
        private var _scaleXY: CGPoint = CGPoint.one

        public var scale: MZFloat  {
            get { return MZFloat(scaleXY.x) }
            set { scaleXY = CGPoint(x: newValue, y: newValue) }
        }

        public var rotation: MZFloat {
            get { return _rotation }
            set {
                _rotation = newValue
                _updateRotation()
                _updateScale()
            }
        }
        private var _rotation: MZFloat = 1.0

        public var actions: [Action] { return _group.updatingActions }

        override init() { super.init() }

        public func setInactive() {
            _activeConditions.removeAll(keepCapacity: false)
            _activeConditions.append({ return false })
        }

        public func addActiveCondition(condition: ()-> Bool) {
            _activeConditions.append(condition)
        }

        public func addAction<T: Action>(action: T, settingAction: ((T) -> ())? = nil) -> T {
            return _group.addAction(action, settingAction)
        }

        public func addActionWithName<T: Action>(name: String, action: T, settingAction: ((T) -> ())? = nil) -> T {
            action.name = name
            return addAction(action, settingAction)
        }

        public func actionWithName(name: String) -> Action? {
            return _group.actionWithName(name)
        }

        public func actionsWithClass(actionClass: AnyClass) -> [Action] {
            return _group.actionsWithClass(actionClass)
        }

        public func actionWithClass(actionClass: AnyClass) -> Action? {
            let actions = actionsWithClass(actionClass)
            MZ.assert(actions.count <= 1, "more actions with this class")

            return actions.first?
        }

        public func actionsWithBaseClass(actionClass: AnyClass) -> [Action] {
            return _group.actionsWithBaseClass(actionClass)
        }

        public func removeAction(action: Action) {
            _willBeRemovedActions.append(action)
        }

        public func removeActionWithName(name: String) {
            _group.removeActionWithName(name)
        }

        public func removeInactiveActions() {
            _group.removeInactiveActions()

            if _willBeRemovedActions.count > 0 {
                for a in _willBeRemovedActions { _group.removeAction(a) }
                _willBeRemovedActions.removeAll(keepCapacity: false)
            }
        }

        public func removeAllActions() {
            _group.removeAllActions()
        }

        public func refresh() {
            _updatePosition()
            _updateScale()
            _updateRotation()
        }

        public override func update() {
            super.update()
            _group.update()
        }

        public override func didFinishUpdate() {
            super.didFinishUpdate()
            _group.didFinishUpdate()
        }



        // MARK: Private

        private var _group: ActionsGroup = ActionsGroup()

        private var  _willBeRemovedActions: [Action] = [Action]()

        private var _activeConditions: Array<(()->Bool)> = Array<(()->Bool)>() // FIXME: 無法寫成: [(()->Bool)]()

        deinit {
            _activeConditions.removeAll(keepCapacity: false)
            _willBeRemovedActions.removeAll(keepCapacity: false)
            _group.removeAllActions()
        }

        private func _updatePosition() {
            for a in _group.updatingActions {
                if let asTran = a as? MZPTransform { asTran.position = self._position }
            }
        }

        private func _updateScale() {
            for a in _group.updatingActions {
                if let asTran = a as? MZPTransform { asTran.scaleXY = _scaleXY }
            }
        }
        private func _updateRotation() {
            for a in _group.updatingActions {
                if let asTran = a as? MZPTransform { asTran.rotation = _rotation }
            }
        }
    }
}