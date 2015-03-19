import Foundation
import SpriteKit

public class SampleScene : MZ.SceneWithQueue {

    public override func didMoveToView(view: SKView) {
//        push(Sample_SKTexture())
//        push(Smaple_SKPhysics())
        push(Sample_PhysicsSTG())
//        push(Sample_PhysicsJoint())
//        push(Sample_PhysicsField())
    }
}
