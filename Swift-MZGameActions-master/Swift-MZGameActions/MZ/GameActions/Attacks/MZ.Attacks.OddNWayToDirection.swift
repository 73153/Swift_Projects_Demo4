import Foundation

extension MZ.Attacks {

    public class OddNWayToDirection : Base {

        public var numberOfWays: Int = 1

        public var targetDirection: MZFloat {
            get { return targetDirectionFunc != nil ? targetDirectionFunc!() : 0 }
            set { targetDirectionFunc = { return newValue } }
        }

        public var targetDirectionFunc: (() -> (MZFloat))? = nil

        public var interval: MZFloat = 0.0

        public var beforeLauchAction: ((OddNWayToDirection)->())? = nil

        public override func start() {
            super.start()
            _colddownCount = 0
        }

        public override func updateWhenActive() {
            super.updateWhenActive()

            if !_checkColddown() { return }
            _launchs()
        }



        // MARK: Private

        private var _colddownCount: MZFloat = 0

        private func _checkColddown() -> Bool {
            _colddownCount -= deltaTime
            if _colddownCount > 0 { return false }

            _colddownCount += colddown;
            return true;
        }

        private func _launchs() {
            if self.targetDirectionFunc == nil { return }

            beforeLauchAction?(self)

            for i in 0..<numberOfWays {
                var sign = MZFloat(i % 2 == 0 ? 1 : -1)

                var multiply = ((i + 1) / 2) as Int
                var degree = MZFloat(multiply) * interval

                let offsetDegrees = degree * sign

                var bullet = bulletWithAppliedSetting()
                if bullet == nil { continue }

                var move = bullet!.actionWithName("move1") as MZ.Moves.VelocityDirection?
                move!.direction = self.targetDirectionFunc!() + offsetDegrees;

                bullet!.rotation = move!.direction;
            }
            
            self.launchCount++;

        }
    }
}
