import Foundation

extension MZ {

    @objc public class ActionsSequence: Action, MZActionsContainer {

        public override var actionTime: ActionTime {
            get { return _actionTime }
            set {
                _actionTime = newValue
                actionsSequence.map { [weak self] (a) in a.actionTime = self!._actionTime }
            }
        }
        private var _actionTime: ActionTime = MZ.ActionTime()

        public override var isActive: Bool { get { return _updatingActionsQueue.count > 0 } }

        private(set) var actionsSequence: [Action] = [Action]()

        init(name: String? = nil, actions: Action ...) {
            super.init()

            if name != nil { self.name = name! }
            for a in actions { addAction(a) }
        }

        deinit {
            removeAllActions()
        }

        public func addAction<T : Action>(action: T, settingAction: ((T) -> ())? = nil) -> T {
            action.actionTime = actionTime
            actionsSequence.append(action)
            settingAction?(action)

            return action
        }

        public func removeAction(action: Action) {
            if let index = find(actionsSequence, action) {
                actionsSequence.removeAtIndex(index)
            }
        }

        public func removeInactiveActions() {
            MZ.assertAlwayFalse("do't use")
        }

        public func removeAllActions() {
            _updatingActionsQueue.removeAll(keepCapacity: false)
            actionsSequence.removeAll(keepCapacity: false)
        }

        public override func start() {
            super.start()

            _copyToUpdatingActionQueue()
            _updatingActionsQueue.first?.start()
        }

        public override func update() {
            super.update()

            _checkNeedToNextAction()
            _updatingActionsQueue.first?.update()
        }



        // MARK: Private

        private var _updatingActionsQueue = [Action]()

        private func _copyToUpdatingActionQueue() {
            _updatingActionsQueue.removeAll(keepCapacity: false)
            for a in actionsSequence {
                _updatingActionsQueue.append(a)
            }
        }

        private func _checkNeedToNextAction() {
            if _updatingActionsQueue.first == nil { return }

            if _updatingActionsQueue.first!.isActive == false {
                _updatingActionsQueue.removeAtIndex(0)

                if _updatingActionsQueue.first != nil { _updatingActionsQueue.first!.start() }
            }
        }

        private func _actionAtIndex(index: Int) -> Action? {
            return 0 <= index && index < actionsSequence.count ? actionsSequence[index] : nil;
        }
    }
}
