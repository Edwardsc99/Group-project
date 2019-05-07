//
//  GameScene.swift
//  new group app
//
//  Created by Liam Driver (s5111108) on 01/05/2019.
//  Copyright © 2019 Liam Driver. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var force = -20.0
    let target = SKSpriteNode(imageNamed: "ColorCircle")
    
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = UIColor.black
        spawnball()
        target.size = CGSize(width: 120.0, height: 120.0)
        target .position = CGPoint(x: frame.midX, y: 150)
        target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)
        target.physicsBody?.isDynamic = false
        addChild(target)
    }
    
    func spawnball() {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = true
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: force))
        
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
