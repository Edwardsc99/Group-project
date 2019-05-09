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
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
  physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor.black
        spawnball()
        target.size = CGSize(width: 120.0, height: 120.0)
        target .position = CGPoint(x: frame.midX, y: 150)
        target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)
        target.zPosition = ZPositions.target
        target.physicsBody?.categoryBitMask = physicsCategories.switchcategory
        target.physicsBody?.isDynamic = false
        addChild(target)
        
       scoreLabel.fontName = "AvenirNext-Bold"
       scoreLabel.fontSize = 60.0
       scoreLabel.fontColor = UIColor.white
       scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
       scoreLabel.zPosition = ZPositions.label
       addChild(scoreLabel)
        
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    func spawnball() {
        currentColourIndex = Int(arc4random_uniform((4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColours.colours[currentColourIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = physicsCategories.ballcategory
        ball.physicsBody?.contactTestBitMask = physicsCategories.switchcategory
        ball.physicsBody?.collisionBitMask = UInt32(physicsCategories.none)
        addChild(ball)
        
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1)  {
            switchState = newState
        } else{
            switchState = .red
        }
        
        target.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
        
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore"){
            UserDefaults.standard.set(score, forKey: "Highscore")
            
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    
    }
    


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == physicsCategories.ballcategory |
            physicsCategories.switchcategory{
            if let ball = contact.bodyA.node?.name == "Ball" ?
                contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColourIndex == switchState.rawValue {
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: { ball.removeFromParent()
                    self.spawnball()
                
            })
            
                } else {
                    gameOver()
}


                }
            }
        }


}
