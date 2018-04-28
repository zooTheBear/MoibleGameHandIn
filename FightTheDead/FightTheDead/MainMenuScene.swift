//
//  MainMenuScene.swift
//  FightTheDead
//
//  Created by Hazem Abo hashima on 2018-04-27.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let playGameText = SKLabelNode (fontNamed: "Chalkduster")
    //let creditsText = SKLabelNode (fontNamed: "Heavy Font")
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        
        // Title Text Line 2 Settings
        let titleTextLine2 = SKLabelNode(fontNamed: "Chalkduster")
        titleTextLine2.text = "Fight The Dead"
        titleTextLine2.fontSize = 150
        titleTextLine2.fontColor = SKColor.white
        titleTextLine2.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.75)
        titleTextLine2.zPosition = 1
        self.addChild(titleTextLine2)
        
        // Title Text Line 3 Settings
        let titleTextLine3 = SKLabelNode(fontNamed: "Chalkduster")
        titleTextLine3.text = "Created by: Zubair Ahmad"
        titleTextLine3.fontSize = 50
        titleTextLine3.fontColor = SKColor.white
        titleTextLine3.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.1)
        titleTextLine3.zPosition = 1
        self.addChild(titleTextLine3)
        
        // Play Game Settings
        playGameText.text = "Play"
        playGameText.fontSize = 125
        playGameText.fontColor = SKColor.white
        playGameText.zPosition = 1
        playGameText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.5)
        self.addChild(playGameText)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if playGameText.contains(pointOfTouch) { // if player touches play game text load game scene
                
                // Green Text to Show the Player they Clicked the Text
                let changeTextColor = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0)
                playGameText.run(changeTextColor)
                
                let callScene = GameScene(size: self.size) // make sure game scene is the same size
                callScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callScene, transition: sceneTransition) // call scene
            }
        }
}
}
