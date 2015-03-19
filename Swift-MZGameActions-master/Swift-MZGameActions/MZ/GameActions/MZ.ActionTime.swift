import Foundation

extension MZ {

    @objc public class ActionTime {

        public enum TimeMode: Int {
            case Frame = 1
            case Time
        }

        public var name: String = "action time"

        public var timeMode: TimeMode {
            get { return _timeMode }
            set {
                _timeMode = newValue
                switch (_timeMode) {
                case TimeMode.Frame:
                    _deltaTimeFunc = { [weak self] (curr) in self!._deltaTimeByFrame(currentTime: curr) }
                case TimeMode.Time:
                    _deltaTimeFunc = { [weak self] (curr) in self!._deltaTimeByTime(currentTime: curr) }
                }
            }
        }
        public var _timeMode: TimeMode = TimeMode.Frame

        public var fps: MZFloat = 30.0

        public var timeScale: MZFloat = 1

        public var deltaTime: MZFloat {
            get {
                return _deltaTime * timeScale
            }
        }

        private(set) var passedTime: MZFloat = 0

        init() {
            timeMode = TimeMode.Frame
        }

        convenience init(timeMode: TimeMode, fps: MZFloat = 30) {
            self.init()
            self.timeMode = timeMode
            self.fps = fps
        }

        public func update(#currentTime: CFTimeInterval) {
            if _preTime < 0 {
                _preTime = currentTime;
                _deltaTime = 0.0;
            } else {
                _deltaTime = _deltaTimeFunc!(curr: currentTime)
                _preTime = currentTime;
                passedTime += _deltaTime
            }
        }



        // MARK: Private

        private var _preTime: MZFloat = -1

        private var _deltaTime: MZFloat = 0.0

        private var _deltaTimeFunc: ((curr: CFTimeInterval) -> MZFloat)?

        private func _deltaTimeByFrame(#currentTime: CFTimeInterval) -> MZFloat {
            if fps <= 0.0 { return 0.0 }
            return 1.0 / fps
        }

        private func _deltaTimeByTime(#currentTime: CFTimeInterval) -> MZFloat {
            var dt = currentTime - _preTime
            _preTime = currentTime

            return dt
        }
    }
}