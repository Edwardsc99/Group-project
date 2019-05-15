import SpriteKit
import Firebase
import FirebaseFirestore

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
    
    let uuid = UUID().uuidString                                                            // this creates a unique user id for identification of the user
    var switchState = SwitchState.red
    var currentColourIndex: Int?
    var force = -20.0
    let target = SKSpriteNode(imageNamed: "ColorCircle")                                    // this creates a sprite for the circle and uses the image colorcirle for the graphics
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0                                                                           // this is the varable for the score which is tracked through the app
    var blingSound: SKAction?
    
    override func didMove(to view: SKView) {
        setupPhysics()                                                                      // this recalls the physics function
        layoutScene()                                                                       // this recalls the layout scene function
        self.blingSound = SKAction.playSoundFileNamed("bling", waitForCompletion: false)
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)                                  //this sets the gravity to minus 1 so the ball is negativly effected by this and heads down.
  physicsWorld.contactDelegate = self
    }

    func save() {
        
        let scoreRef = Firestore.firestore().collection("scores").document(uuid)            // this then sets the score reference to the a firestore in firebase
        scoreRef.setData(["score": score]) { error in }                                     // this sets the data of the score to be sent to firebase

    }
    
    func layoutScene() {
        backgroundColor = UIColor.black
        spawnball()
        target.size = CGSize(width: 120.0, height: 120.0)                                  //this is where the size of the circle is set
        target .position = CGPoint(x: frame.midX, y: 150)                                   // this is where the position of the circle is
        target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)             // this sets the physics body to be half the size of the circle
        target.zPosition = ZPositions.target
        target.physicsBody?.categoryBitMask = physicsCategories.switchcategory
        target.physicsBody?.isDynamic = false                                               // this sets it so that gravity doesnt effect the ball
        addChild(target)                                                                    // this adds the circle to the scene
        
       scoreLabel.fontName = "AvenirNext-Bold"                                              // this creates the score label by setting the font, font size, color, position and adds to the scene
       scoreLabel.fontSize = 60.0
       scoreLabel.fontColor = UIColor.white
       scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
       scoreLabel.zPosition = ZPositions.label
       addChild(scoreLabel)
        
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"                                                    // this function updates the scorelabel with the score
    }
    
    func spawnball() {
        currentColourIndex = Int(arc4random_uniform((4)))                               // this randomly selects a color for the ball
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColours.colours[currentColourIndex!], size: CGSize(width: 30.0, height: 30.0))       //this sets up the ball sprite with size, position and a physicsbody
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
        
        target.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))                         // this rotates the wheel 90 degrees anti clockwise
        
    }
    
    func gameOver() {                                                                       // this is the gameover/reset function
        run(SKAction.playSoundFileNamed("game_over", waitForCompletion: true)){
            UserDefaults.standard.set(self.score, forKey: "RecentScore")                    // this sets the recentscore label to the score of the previous game
            if self.score > UserDefaults.standard.integer(forKey: "Highscore"){
                UserDefaults.standard.set(self.score, forKey: "Highscore")                  // this then sets the highscore label if the score just obtained then it changes this label as well
            
        }
        
        let menuScene = MenuScene(size: self.view!.bounds.size)
        self.view!.presentScene(menuScene)                                                  // this then presents the menu scene
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()                                                                         // this turns the wheel when the user touches the screen
    }
    }
    


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask             // this recalls the contact masks of both sprites into one function
        
        if contactMask == physicsCategories.ballcategory |
            physicsCategories.switchcategory{
            if let ball = contact.bodyA.node?.name == "Ball" ?                                      //this checks the contact is with the ball
                contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColourIndex == switchState.rawValue {                                     // this checks if color is the matches with both the ball and the wheel
                    if blingSound == self.blingSound{                                               // this runs if the color is correct
                        run(blingSound!)
                    }
                    score += 1                                                                      // adds one to the score
                    if score > 5 {                                                                  // this then adds to the gravity if the score of 6,11,21,26 are reached
                        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
                    }
                    if score > 10 {
                        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
                    }
                    if score > 20 {
                        physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
                    }
                    if score > 25 {
                        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.0)
                    }
                    updateScoreLabel()                                                              // this then updates the score label
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: { ball.removeFromParent()                // removes the ball from the parent and fades it out
                    self.spawnball()                                                                                    // then spawns another ball
                
            })
            
                } else {
                    save()                                                                                      // otherwise runs the save function
                    gameOver()                                                                                  // and restarts the add
                    
}


                }
            }
        }


}
