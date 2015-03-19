import Foundation

extension MZ {

    @objc public class ActionRepeat: Action {

        public override var isActive: Bool { get { return _repeatTimesCount >= 0 } }

        init(action: Action, repeatTimes: Int) {
            _action = action
            _repeatTimes = repeatTimes
            super.init()
        }

        convenience init(foreverAction: Action) {
            self.init(action: foreverAction, repeatTimes: 1)
            _isForever = true
        }

        public override func start() {
            super.start()
            _repeatTimesCount = _repeatTimes;
            _currentUpdatingAction = nil
        }

        public override func update() {
            if !isActive { return }

            super.update()

            _checkNeedNextToAction()
            _currentUpdatingAction?.update()
            _checkActionEnd()
        }



        // MARK: Private

        private var _action: Action

        private var _currentUpdatingAction: Action? = nil

        private var _isForever: Bool = false

        private var _repeatTimes: Int = 0

        private var _repeatTimesCount: Int = 0

        private func _checkNeedNextToAction() {
            if _currentUpdatingAction != nil { return }
            _repeatTimesCount = _isForever ? 1 : _repeatTimesCount - 1

            if _repeatTimesCount < 0 { return }

            _currentUpdatingAction = _action
            _currentUpdatingAction!.start()
        }

        private func _checkActionEnd() {
            if _currentUpdatingAction == nil { return }
            if _currentUpdatingAction!.isActive { return }

            _currentUpdatingAction = nil
        }

        private func _checkAndSetRepaet() {
            if _action.isActive { return }

            if _repeatTimesCount > 0 {
                _repeatTimesCount--

                if _isForever { _repeatTimesCount = 1 }
                if _repeatTimesCount > 0 { _action.start() }
            }
        }
    }
}
