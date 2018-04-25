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
            var attackingAWall = false
             for wall in walls {
                let collisionWall = zombie.collision(items: [wall]).first
                
                //if a zombie collides with a wall
                //if(!attackingAWall)
                //{
                if (wall.dead)
                {
                    //wall.removeFromParent()
                    //toBeDeleted.append(walls.index(of: wall)!)
                    let fire = Bundle.main.path(forResource: "MyParticle", ofType: "sks")!
                    let death = NSKeyedUnarchiver.unarchiveObject(withFile: fire) as! SKEmitterNode
                    death.xScale = 1
                    death.yScale = 1
                    death.position.x = wall.position.x
                    death.position.y = wall.position.y
                    death.zPosition = 10
                    self.addChild(death)
                    
                    wall.position.x = -10000
                    
                }
                if let _ = collisionWall {
                    if(!zombie.attacking)
                    {
                        print("Calling")
                        zombie.attackWall()
                    }
                    wall.takeDamge(damgeAmount: 2)
                    attackingAWall = true
                }
                else if(zombie.attacking)
                {
                    zombie.walk()
                }
                //}
            }
            print(walls.count)
            if(walls.count == 0)
            {
                if(zombie.attacking)
                {
                    zombie.walk()
                }
            }
        }
        //deleteZombies(toBeDeleted)
        
        //deleteWalls(wallsToBeDeleted)
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
    
    
    private func deleteZombies(_ zombieIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = zombieIndexes.reversed()
        
        for index in reversedIndexes {
            zombies.remove(at: index)
        }
    }
}

