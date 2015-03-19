// 感覺上會快就會需要 enableUpdate 這種東西了(如同 pasue 這項 Action 的意思)

// update flow 設計準則: 三段細分, 彼此獨立
// 指標 _curr 指向目前
// step.1 (start) if _curr == nil => _curr = 嘗試取出 action, _curr.start()
// step.2 (update) if _curr != nil => _curr.update() (update 內建 isActive == false 時不執行)
// step.3 (end) _curr!.isActive == false => _curr!.end() => _curr = nil

import Foundation

extension MZ {

    @objc public class Action : NSObject, MZPAction, Equatable {

        public var name: String = ""

        public var isActiveFunc: ((action: Action) -> Bool)?

        public var enable: Bool = true

        public var startAction: ((action: Action) -> ())?

        public var updateAction: ((action: Action) -> ())?

        public var didFinishUpdateAction: ((action: Action) -> ())?

        public var endAction: ((action: Action) -> ())?

        public var deinitAction: ((action: Action) -> ())?

        public var duration: MZFloat? = nil

        public var timeScale: MZFloat = 1

        public var actionTime: ActionTime = ActionTime()

        public var isActive: Bool {
            get {
                if duration != nil && passedTime >= duration { return false }
                return isActiveFunc != nil ? isActiveFunc!(action: self) : true
            }
        }

        public var deltaTime: MZFloat { get { return actionTime.deltaTime * timeScale } }

        public var passedTime: MZFloat {  get { return  _passedTime } }
        public var _passedTime: MZFloat = MZFloat.infinity

        override init() {
            super.init()
            _currentStartInvoke = { [weak self] in self!.start() }
            _currentEndInvoke = { [weak self] in self!.end() }
        }

        convenience init(name: String) {
            self.init()
            self.name = name
        }

        convenience init(settingAction: ((MZ.Action)->())?) {
            self.init()
            settingAction?(self)
        }

        public func start() {
            _currentStartInvoke = nil
            _currentEndInvoke = { [weak self] in self!.end() }

            _passedTime = 0
            startAction?(action: self)
        }

        public func update() {
            _currentStartInvoke?()
            if isActive && enable { updateWhenActive() }
            if !isActive { _currentEndInvoke?() }
        }

        public func didFinishUpdate() {
            didFinishUpdateAction?(action: self)
        }

        public func end() {
            _currentEndInvoke = nil
            endAction?(action: self)
        }

        public func updateWhenActive() {
            _updatePassedTime()
            updateAction?(action: self)
        }

        // MARK: Private

        private var _currentStartInvoke: (() -> ())? = nil

        private var _currentEndInvoke: (() -> ())? = nil

        deinit {
            deinitAction?(action: self)
            deinitAction = nil

            _currentStartInvoke = nil
            _currentEndInvoke = nil
        }

        private func _updatePassedTime() { _passedTime += self.deltaTime }
    }
}

public func ==(lhs: MZ.Action, rhs: MZ.Action) -> Bool {
    return lhs === rhs
}