//
//  GameScene.swift
//  ZombieConga
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spawnManager: ZombieSpawner?
    private var zombies: [Zombie] = []
    private let background = SKSpriteNode(imageNamed: "background1")
    
    //level setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        spawnManager = ZombieSpawner(givenSpawnArea: CGRect(x: self.size.width + 10 , y: 200, width: 100, height: self.size.height-200), min: 1, max: 4);
        spawnManager?.scene = self
        backgroundColor = SKColor.black
        background.zPosition = -1
        background.size = self.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        addChild(background)
    }
    
    deinit {
        zombies = []
    }
    
    /// update method
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // getting all gameObjects from the sceneGraph
        let gameObjects: [GameObject?] = self.children.flatMap { node in
            guard let gameObject = node as? GameObject else {
                return nil
            }
            return gameObject
        }
        
        // calling update on all of them
        for gameObject in gameObjects {
            gameObject?.update(currentTime)
        }
        
        // Collision detection and cleanup
        var toBeDeleted : [Int] = []
        
        for zombie in zombies {
            // collision code here, only returns an object if a collision occured
            // we can assume that there is only ever going to be one ".first"
            // because we are checking each zombie against only the player.
            //let catlady = zombie.collision(items: [player]).first
            
            // if a zombie collides
            //if let _ = catlady {
              //  print("Collision")
                // removing the zombie from the scene
                //zombie.removeFromParent()
                
                // putting the index of the current zombie on a list to remove our local reference
                //toBeDeleted.append(zombies.index(of: zombie)!)
            //}
        }
        
        deleteZombies(toBeDeleted)
        guard let zombie = spawnManager?.update(time: currentTime) else {
            return
        }
        zombies.append(zombie)
    }
    
    //on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else {
            return
        }
        
    }
    
    /// we use this helper function to delete things from our zombie array
    ///
    /// - Parameter zombieIndexes: the indexes of zombies to be deleted from the zombie array
    private func deleteZombies(_ zombieIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = zombieIndexes.reversed()
        
        for index in reversedIndexes {
            zombies.remove(at: index)
        }
    }
}

