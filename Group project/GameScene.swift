import SpriteKit

enum PlayColours {
    static let colours = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}
enum SwitchState: Int {
    case red, yellow, green, blue
}



class GameScene: SKScene {

    var switchState = SwitchState.red
    var currentColourIndex: Int?
    var force = -20.0
    let target = SKSpriteNode(imageNamed: "ColorCircle")
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
  physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor.black
        spawnball()
        target.size = CGSize(width: 120.0, height: 120.0)
        target .position = CGPoint(x: frame.midX, y: 150)
        target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)
        target.physicsBody?.categoryBitMask = physicsCategories.switchcategory
        target.physicsBody?.isDynamic = false
        addChild(target)
    }
    
    func spawnball() {
        currentColourIndex = Int(arc4random_uniform((4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColours.colours[currentColourIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = physicsCategories.ballcategory
        ball.physicsBody?.contactTestBitMask = physicsCategories.switchcategory
        ball.physicsBody?.collisionBitMask = UInt32(physicsCategories.none)
        addChild(ball)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        force += 0.2
        let touch = touches.first!
        let touchLocation = touch.location(in: self)

        if touchLocation.x > frame.midX {
            target.zRotation += deg2rad(90)
        } else {
            target.zRotation -= deg2rad(90)
        }
        
    }
    
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in children {
            if child.position.y < -100 {
                child.removeFromParent()
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == physicsCategories.ballcategory |
            physicsCategories.switchcategory{
            
    }
}




}
