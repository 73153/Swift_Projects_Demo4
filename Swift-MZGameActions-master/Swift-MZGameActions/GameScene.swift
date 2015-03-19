import SpriteKit

class GameScene: SKScene {

    override func didMoveToView(view: SKView) {
//        for i in 1...500 {
//            let color = SKColor(
//                red: MZ.Maths.randomFloat(min: 0, max: 1.0).toCGFloat(),
//                green: MZ.Maths.randomFloat(min: 0, max: 1.0).toCGFloat(),
//                blue: MZ.Maths.randomFloat(min: 0, max: 1.0).toCGFloat(),
//                alpha: MZ.Maths.randomFloat(min: 0, max: 1.0).toCGFloat()
//            )
//
//            let size = CGSize(
//                width: MZ.Maths.randomFloat(min: 10.0, max: 30.0).toCGFloat(),
//                height: MZ.Maths.randomFloat(min: 10.0, max: 30.0).toCGFloat()
//            )
//
//            let pos = CGPoint(
//                x: MZ.Maths.randomInt(10...Int(self.size.width - 10)),
//                y: MZ.Maths.randomInt(10...Int(self.size.height - 10))
//            )
//
//            var s = SKSpriteNode(color: color, size: size)
//            s.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(M_PI.toCGFloat(), duration: 2)))
//            addChild(s)
//            s.position = pos
//        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}