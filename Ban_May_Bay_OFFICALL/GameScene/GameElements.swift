//
//  GameElements.swift
//  Ban_May_Bay_OFFICALL
//
//  Created by My iMac on 9/9/18.
//  Copyright © 2018 My iMac. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    struct PhysicContact {
        static let alienPhysic:UInt32 = 0x1 << 1
        static let torpedoPhysic:UInt32 = 0x1 << 0
    }
    
    func addLives() {
        livesArray = [SKSpriteNode]()
        
        for live in 1...3 {
            let liveNode = SKSpriteNode(imageNamed: "shuttle")
            liveNode.size = CGSize(width: liveNode.size.width*2, height: liveNode.size.height*2)
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: self.frame.size.height - 60)
            liveNode.zPosition = 6
            
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    @objc func addAlien() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 800)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        alien.size = CGSize(width: alien.size.width*2, height: alien.size.height*2)
        
        alien.physicsBody = SKPhysicsBody(circleOfRadius: alien.size.width)
        alien.physicsBody?.contactTestBitMask = PhysicContact.alienPhysic
        self.addChild(alien)
        
        let animationDuration: TimeInterval = 6
        
        let move = SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration)
        let remove = SKAction.removeFromParent()
        let lives = SKAction.run {
                    if self.livesArray.count > 0 {
                        let liveNode = self.livesArray.first
                        liveNode?.removeFromParent()
                        self.livesArray.removeFirst()
        
                        if self.livesArray.count == 0 {

                            if let scene = SKScene(fileNamed: "GameOver") {
                                scene.scaleMode = .aspectFill
                                self.view?.presentScene(scene)
                            }
                        }
                    }
                }
        alien.run(SKAction.sequence([move, remove, lives]))
    }
    
    func fireTorpedo() {
        run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.size = CGSize(width: torpedoNode.size.width*2, height: torpedoNode.size.height*2)
        torpedoNode.position.y += 10
        torpedoNode.zPosition = 0
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width/2)
        torpedoNode.physicsBody?.contactTestBitMask = PhysicContact.torpedoPhysic
        
        self.addChild(torpedoNode)
        
        let move = SKAction.move(to: CGPoint(x: player.position.x, y: 1400), duration: 0.3)
        
        let remove = SKAction.removeFromParent()
        
        torpedoNode.run(SKAction.sequence([move,remove]))
    }
}
