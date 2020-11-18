//
//  GameScene.swift
//  Ban_May_Bay_OFFICALL
//
//  Created by My iMac on 9/9/18.
//  Copyright © 2018 My iMac. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var startField = SKEmitterNode(fileNamed: "Starfield")
    var explosion: SKEmitterNode!
    
    var player = SKSpriteNode(imageNamed: "shuttle")
    var torpedoNode: SKSpriteNode!
    var livesArray: [SKSpriteNode]!
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    var gameTimer: Timer!
    var gameOverLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        addLives()
        
        self.scene?.backgroundColor = UIColor.black
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        startField?.position = CGPoint(x: self.frame.size.width/2, y: 1350)
        startField?.zPosition = -1
        startField?.advanceSimulationTime(5)
        self.addChild(startField!)
        
        player.position = CGPoint(x: self.frame.width/2, y: 80)
        player.size = CGSize(width: player.size.width*2, height: player.size.height*2)
        player.zPosition = 1
        self.addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 150, y: 1250)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor.white
        self.addChild(scoreLabel)
        
        var timeInterval: Float = 1
        
        if UserDefaults.standard.bool(forKey: "Hard") {
            timeInterval = 0.5
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = contact.bodyA
        var secondBody = contact.bodyB
        
        let contactMask = firstBody.contactTestBitMask | secondBody.contactTestBitMask
        
        
        if contactMask == (PhysicContact.torpedoPhysic | PhysicContact.alienPhysic) {
            explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion.position =  (firstBody.node?.position)!
            self.addChild(explosion)
            
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
            self.run(SKAction.wait(forDuration: 2)) {
                self.explosion.removeFromParent()
            self.score += 5
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
}
