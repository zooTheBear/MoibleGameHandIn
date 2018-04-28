//
//  GameOverScene.swift
//  FightTheDead
//
//  Created by Hazem Abo hashima on 2018-04-27.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let playAgainText = SKLabelNode (fontNamed: "Chalkduster")
    let mainMenuText = SKLabelNode (fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        
        // Background Settings
        let background = SKSpriteNode (imageNamed: "background1")
        background.size = self.size // Set Size of Background as the same size of the scene
        background.position = CGPoint (x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0 // Put Background furthur back
        self.addChild(background) // Add Background to the scene
        
        // Game Over Text Settings
        let gameOverText = SKLabelNode(fontNamed: "Chalkduster")
        gameOverText.text = "Game Over"
        gameOverText.fontSize = 200
        gameOverText.fontColor = SKColor.white
        gameOverText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.85)
        gameOverText.zPosition = 1
        self.addChild(gameOverText)
        
        // Score Text Settings
        let scoreText = SKLabelNode(fontNamed: "Chalkduster")
        scoreText.text = "Score: \(finalScore)"
        scoreText.fontSize = 125
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.5)
        scoreText.zPosition = 1
        self.addChild(scoreText)
        
        let waveText = SKLabelNode(fontNamed: "Chalkduster")
        waveText.text = "Waves Survived: \(finalWave)"
        waveText.fontSize = 110
        waveText.fontColor = SKColor.white
        waveText.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.4)
        waveText.zPosition = 1
        self.addChild(waveText)
        
        // High Score Settings
        let defaultsScore = UserDefaults ()
        var highScoreNumber = defaultsScore.integer(forKey: "highScoreSaved")
        
        if finalScore > highScoreNumber { // if current score is greater than the high score
            highScoreNumber = finalScore // set new high score
            defaultsScore.set(highScoreNumber, forKey: "highScoreSaved") // save as new high score
        }
        
        let highScoreText = SKLabelNode(fontNamed: "Chalkduster")
        highScoreText.text = "High Score: \(highScoreNumber)" // update high score text with high score number
        highScoreText.fontSize = 125
        highScoreText.fontColor = SKColor.white
        highScoreText.zPosition = 1
        highScoreText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.7)
        self.addChild(highScoreText)
        
        
        // Play Again Settings
        playAgainText.text = "Play Again"
        playAgainText.fontSize = 90
        playAgainText.fontColor = SKColor.white
        playAgainText.zPosition = 1
        playAgainText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.2)
        self.addChild(playAgainText)
        
        // Main Menu Settings
        mainMenuText.text = "Main Menu"
        mainMenuText.fontSize = 90
        mainMenuText.fontColor = SKColor.white
        mainMenuText.zPosition = 1
        mainMenuText.position = CGPoint (x: self.size.width / 2, y: self.size.height * 0.1)
        self.addChild(mainMenuText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches { // check all touches that were made
            
            let pointOfTouch = touch.location(in: self) // check where the touch was made
            
            // See if the touch was the test play again text
            if playAgainText.contains(pointOfTouch) {
                
                // Green Text to Show the Player they Clicked the Text
                let changePATextColor = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0)
                playAgainText.run(changePATextColor)
                
                let callScene = GameScene(size: self.size) // make sure game scene is the same size
                callScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callScene, transition: sceneTransition) // call scene
            }
            
            // See if the touch was the test play again text
            if mainMenuText.contains(pointOfTouch) {
                
                // Green Text to Show the Player they Clicked the Text
                let changeMMTextColor = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0)
                mainMenuText.run(changeMMTextColor)
                
                let callMenuScene = MainMenuScene(size: self.size) // make sure main menu scene is the same size
                callMenuScene.scaleMode = self.scaleMode // same goes for the scale
                let sceneMenuTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                self.view!.presentScene(callMenuScene, transition: sceneMenuTransition) // call scene
                
            }
        }
    }
}
