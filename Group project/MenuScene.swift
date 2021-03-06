//
//  MenuScene.swift
//  Group project
//
//  Created by Jasmin Friedrich (s5127222) on 09/05/2019.
//  Copyright © 2019 Christian Edwards (s5109267). All rights reserved.
//

import SpriteKit


class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        addLogo()
        backgroundColor = UIColor.black                                     // this sets the background color to black
        addLabels()
        
    }

    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "ColorCircle")                                      // Logo should appear
        logo.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.midY + frame.size.height/4)
        addChild(logo)
        
    }
    func addLabels() {
        
        let playLabel = SKLabelNode (text: "Tap to Play!")                                                                                      //Creates the tap to play label
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highScoreLabel = SKLabelNode(text: "Highscore: " + "\( UserDefaults.standard.integer(forKey: "Highscore"))")                        //creates the highscore label
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 40.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height*4)
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode (text: "Recent Score: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")                 //creates recent score label
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 40.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
        
    }
    func animate(label:SKLabelNode){
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)                                                        //this is to animate the tap to play label and make it pulse
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {                                     //to add function of starting the game
        let gameScene = GameScene(size:view!.bounds.size)
        view!.presentScene(gameScene)
        
    }
    
}
