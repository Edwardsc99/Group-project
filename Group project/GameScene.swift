//
//  GameScene.swift
//  new group app
//
//  Created by Liam Driver (s5111108) on 01/05/2019.
//  Copyright © 2019 Liam Driver. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var yellow: SKSpriteNode!
    var blue :SKSpriteNode!
    var red: SKSpriteNode!
    var green: SKSpriteNode!
    
    let ball = SKSpriteNode(imageNamed: "ball")
    
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = UIColor.black
        
        
        
        
        spawnball()
    }
    
    func spawnball() {
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball .position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(ball)
    }
    
    func spriteSetup(){
        
        yellow = SKSpriteNode()
        yellow.size = CGSize(width: frame.size.width/3, height: frame.size.height/3)
        addChild(yellow)
        
        red = SKSpriteNode()
        red.size = CGSize(width: frame.size.width/3, height: frame.size.height/3)
        addChild(red)
        
        blue = SKSpriteNode()
        blue.size = CGSize(width: frame.size.width/3, height: frame.size.height/3)
        addChild(blue)
        
        green = SKSpriteNode()
        green.size = CGSize(width: frame.size.width/3, height: frame.size.height/3)
        addChild(green)
        
    }
}
