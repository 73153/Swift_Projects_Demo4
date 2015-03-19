import Foundation

extension MZ {

    @objc public class ActionsGroup: Action, MZActionsContainer {

        public var count: Int { get { return _updatingAciotns.count + _newActionsBuffer.count } }

        private (set) var isUpdating: Bool = false

        public override var isActive: Bool {
            get {
                if _newActionsBuffer.count > 0 { return true }
                for a in _updatingAciotns { if a.isActive { return true } }

                return false;
            }
        }

        public override var actionTime: ActionTime {
            get { return _actionTime }
            set {
                _actionTime = newValue
                _updatingAciotns.map  { [weak self] (a) in a.actionTime = self!._actionTime }
                _newActionsBuffer.map { [weak self] (a) in a.actionTime = self!._actionTime }
            }
        }
        private var _actionTime: ActionTime = ActionTime()

        public var updatingActions: [Action] { get { return _updatingAciotns } }

        // TODO: 追加這個 --> init(actions: Action ...) {

        public func actionWithName(name: String) -> Action? {
            for a in _updatingAciotns {
                if a.name == "" { continue }
                if a.name == name { return a }
            }

            for a in _newActionsBuffer {
                if a.name == "" { continue }
                if a.name == name { return a }
            }

            return nil
        }

        public func actionsWithClass(actionClass: AnyClass) -> [Action] {
            var actions = [Action]()

            // TODO: better way to do this in Swift? use objc way now >_<
            for a in _updatingAciotns {
                if a.isMemberOfClass(actionClass) {
                    actions.append(a)
                }
            }

            for a in _newActionsBuffer {
                if a.isMemberOfClass(actionClass) {
                    actions.append(a)
                }
            }

            // 參考可用的 code
//            var finds = _updatingActions.filter { (a) in a.class == class }
//            if finds.count > 0 { return finds[0] }

            return actions
        }

        public func actionsWithBaseClass(actionClass: AnyClass) -> [Action] {
            var finds1 = _updatingAciotns.filter { (a) in a.isKindOfClass(actionClass) }
            var finds2 = _newActionsBuffer.filter { (a) in a.isKindOfClass(actionClass) }

            return finds1 + finds2
        }

        public func addAction<T: Action>(action: T, settingAction: ((T) -> ())? = nil) -> T {
            var a: T!
            if !isUpdating {
                a = _addActionToUpdating(action, settingAction: settingAction)
            } else {
                a = _addActionToLateBuffer(action, settingAction: settingAction)
            }

            return a
        }

        public func removeAction(action: Action) {
            if let index = find(_updatingAciotns, action) {
                _updatingAciotns.removeAtIndex(index)
            } else if let index = find(_newActionsBuffer, action) {
                _newActionsBuffer.removeAtIndex(index)
            }
        }

        public func removeActionLate(action: Action) {
            _lateRemoveActionsBuffer.append(action)
        }

        public func removeActionWithName(name: String) {
            var rmTarget = actionWithName(name)
            if rmTarget == nil { return }
            removeAction(rmTarget!)
        }

        public func removeActionLateWithName(name: String) {
            _lateRemoveActionsBuffer.append(actionWithName(name)!)
        }

        public func removeAllActions() {
            _updatingAciotns.removeAll(keepCapacity: false)
            _newActionsBuffer.removeAll(keepCapacity: false)
            _lateRemoveActionsBuffer.removeAll(keepCapacity: false)
        }

        public override func start() {
            super.start()
            _updatingAciotns.map { (a) in a.start() }
        }

        public override func update() {
            super.update()

            isUpdating = true

            _removeActionsFromBuffer()
            _moveBufferActionToUpdating()
            _updatingAciotns.map { (a) in a.update() }
        }

        public override func end() {
            super.end()
            isUpdating = false
        }

        public override func didFinishUpdate() {
            super.didFinishUpdate()
            _updatingAciotns.map { (a) in a.didFinishUpdate() }
        }

        public func removeInactiveActions() {
            for var i = 0; i < _updatingAciotns.count; i++ {
                if _updatingAciotns[i].isActive == true { continue }
                _updatingAciotns.removeAtIndex(i)
                --i
            }
        }



        private var _updatingAciotns: [Action] = [Action]()

        private var _newActionsBuffer: [Action] = [Action]()

        private var _lateRemoveActionsBuffer: [Action] = [Action]()

        deinit {
            removeAllActions()
        }

        private func _addActionToUpdating<T: Action>(action: T, settingAction: ((T) -> ())? = nil) -> T {
            action.actionTime = actionTime
            _updatingAciotns.append(action)

            settingAction?(action)

            action.start()

            return action
        }

        private func _addActionToLateBuffer<T: Action>(action: T, settingAction: ((T) -> ())? = nil) -> T {
            action.actionTime = actionTime
            _newActionsBuffer.append(action)

            settingAction?(action)
            
            return action
        }

        private func _moveBufferActionToUpdating() {
            for a in _newActionsBuffer {
                _updatingAciotns.append(a)
                a.start()
            }

            _newActionsBuffer.removeAll(keepCapacity: false)
        }

        private func _removeActionsFromBuffer() {
            for a in _lateRemoveActionsBuffer {
                removeAction(a)
            }
            _lateRemoveActionsBuffer.removeAll(keepCapacity: false)
        }
    }
}
