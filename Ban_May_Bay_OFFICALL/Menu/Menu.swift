//
//  Menu.swift
//  Ban_May_Bay_OFFICALL
//
//  Created by My iMac on 9/9/18.
//  Copyright © 2018 My iMac. All rights reserved.
//

import SpriteKit

class Menu: SKScene {

    var startfield: SKEmitterNode!
    
    var newGameNode: SKSpriteNode!
    var difficultyNode: SKSpriteNode!
    var difficultLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        startfield = self.childNode(withName: "startField") as! SKEmitterNode
        startfield.zPosition = -1
        startfield.advanceSimulationTime(10)
        
        newGameNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        difficultyNode = self.childNode(withName: "difficultyBtn") as! SKSpriteNode
        difficultLabel = self.childNode(withName: "difficultyLbl") as! SKLabelNode
        
        var userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hard") {
            difficultLabel.text = "hard"
        } else {
            difficultLabel.text = "Easy"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameBtn" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "difficultyBtn" {
                changeDifficulty()
            }
        }
    }
    
    func changeDifficulty() {
        if difficultLabel.text == "Easy" {
            difficultLabel.text = "Hard"
        } else {
            difficultLabel.text = "Easy"
        }
    }
}

