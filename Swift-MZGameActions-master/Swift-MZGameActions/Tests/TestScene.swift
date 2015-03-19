import SpriteKit

public class TestScene: MZ.SceneWithQueue {

    public override func didMoveToView(view: SKView) {
//        push(TestActionOnce())
//        push(TestActionUpdate())
//        push(TestActionDifferentTimeScale())
//        push(TestActionsChangeTimeScaleOnFly())
//        push(TestActionsGroup())
//        push(TestActionsGroupAddRevmoeOnFly())
//        push(TestActionsSequence())
//        push(TestActionRepeat())
//        push(TestActorWithNode())
//        push(TestPoolWithNodes())
//        push(TestTouchRelativeMoveAndBound())
//        push(TestBoundTest())
//        push(TestSpriteCircleCollider())
//        push(TestActionTime())
//        push(TestIOS8SK_LightNode())
        push(TestMZActionWithSKPhysics())
//        push(TestMoves())
    }
}