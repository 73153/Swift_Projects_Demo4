import Foundation

@objc public protocol MZPoolElement {
    var pool: MZ.Pool? { get set }
    var poolElementIndex: Int { get set }

    func returnToPool()
}

extension MZ {
    // 無法加入 generic 支援, 因為 SpriteKit 還是 object-c,
    @objc public class Pool {

        private(set) var poolElements: [MZPoolElement] = [MZPoolElement]()

        public var totalElements: Int { get { return poolElements.count } }

        public var numberOfAvailable: Int {
            get {
                var count = 0
                for b in _poolElementStates { if !b { count++ } }
                return count
            }
        }

        public var getAction: ((MZPoolElement) -> ())?

        public var returnAction: ((MZPoolElement) -> ())?

        init(
            numberOfElements: Int,
            elementGenFunc: ()->(MZPoolElement),
            getAction: ((MZPoolElement) -> ())? = nil,
            returnAction: ((MZPoolElement) -> ())? = nil
            )
        {
            self.getAction = getAction
            self.returnAction = returnAction

            for i in 0..<numberOfElements {
                var e = elementGenFunc()

                e.pool = self
                e.poolElementIndex = i

                poolElements.append(e)
                _poolElementStates.append(false)
            }
        }

        deinit {
            clear()
        }

        public func getElement() -> MZPoolElement? {
            for i in 0..<_poolElementStates.count {
                let index = _currentIndex
                _currentIndex = (_currentIndex + 1) % _poolElementStates.count;

                if _poolElementStates[index] == false {
                    _poolElementStates[index] = true

                    var e = poolElements[index]
                    getAction?(e)

                    return e
                }
            }

            return nil
        }

        public func returnElement(e: MZPoolElement) {
            if !containElement(e) { return }

            returnAction?(e)
            _poolElementStates[e.poolElementIndex] = false
        }

        public func containElement(element: MZPoolElement) -> Bool {
            for e in poolElements { if e === element { return true } }
            return false
        }

        public func clear() {
            poolElements.removeAll(keepCapacity: false)
            _poolElementStates.removeAll(keepCapacity: false)

            getAction = nil
            returnAction = nil
        }

        // MARK: Private

        private var _poolElementStates: [Bool] = [Bool]()

        private var _currentIndex: Int = 0
    }
}
