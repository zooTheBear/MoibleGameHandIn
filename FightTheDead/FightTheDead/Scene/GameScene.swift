//
//  GameScene.swift
//  ZombieConga
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spawnManager: ZombieSpawner?
    private var zombies: [Zombie] = []
    private var walls: [Wall] = []
    //private var turrets: [Turret] = []
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
        walls = []
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
            
             for wall in walls {
                
                if(wall.dead)
                {
                    wall.removeFromParent()
                    
                }
                else
                {
                    let collisionWall = zombie.collision(items: [wall]).first
                    print("Collision")
                    // if a zombie collides with a wall
                    if let _ = collisionWall {
                        print("Collision")
                        if(!zombie.attacking)
                        {
                            zombie.attackWall()
                        }
                    }
                }
            }
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
        
        if let touch = touches.first {
            let position = touch.location(in: self)
            print(position.x)
            print(position.y)
            
            let newWall = Wall()
            addChild(newWall)
            newWall.position =  position
            walls.append(newWall)
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

