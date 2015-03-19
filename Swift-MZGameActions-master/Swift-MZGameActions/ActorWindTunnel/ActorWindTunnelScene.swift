import Foundation
import SpriteKit

public class ActorWindTunnelScene : MZ.SceneWithQueue {

    public var currentActorWindTunnel: ActorWindTunnel? {
        get { return self.currentActionElement? as? ActorWindTunnel }
    }

    public override func didMoveToView(view: SKView) {
        push(ActorWindTunnel(scene: self))
    }
}