//
//  GameScene.swift
//  ZombieConga
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var coinLabel: SKLabelNode!
    var scoreLable: SKLabelNode!
    
    var coins = 100 {
        didSet {
            coinLabel.text = "Coins: \(coins)"
        }
    }
    var score = 0 {
        didSet {
            scoreLable.text = "Score: \(score)"
        }
    }
    
    
    private var spawnManager: ZombieSpawner?
    private var zombies: [Zombie] = []
    private var walls: [Wall] = []
    private var turrets: [Turret] = []
    private var shots: [Shot] = []
    //private var turrets: [Turret] = []
    private let background = SKSpriteNode(imageNamed: "background1")
    private let selectWallImage = SKSpriteNode(imageNamed: "wallSelect")
    private let selectTurretImage = SKSpriteNode(imageNamed: "FinalTurretSelect")
    
    var turretIsSelected = false
    var wallIsSelected = false
    
    //level setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        spawnManager = ZombieSpawner(givenSpawnArea: CGRect(x: self.size.width + 10 , y: 200, width: 100, height: self.size.height-200), min: 1, max: 4);
        spawnManager?.scene = self
        backgroundColor = SKColor.black
        background.zPosition = -1
        background.size = self.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        
        selectTurretImage.zPosition = 0
        selectTurretImage.size = CGSize(width: 150, height: 75)
        selectTurretImage.position = CGPoint(x: 300, y: 100)
        
        selectWallImage.zPosition = 0
        selectWallImage.size = CGSize(width: 150, height: 75)
        selectWallImage.position = CGPoint(x: 600, y: 100)
        
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel.text = "Coins: 100"
        coinLabel.horizontalAlignmentMode = .right
        coinLabel.position = CGPoint(x: self.position.x+200, y: self.size.height-100)
        
        scoreLable = SKLabelNode(fontNamed: "Chalkduster")
        scoreLable.text = "Score: 0"
        scoreLable.horizontalAlignmentMode = .right
        scoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height-100)
        
        
        addChild(scoreLable)
        addChild(coinLabel)
        
        
        addChild(selectWallImage)
        addChild(selectTurretImage)
        addChild(background)
    }
    
    deinit {
        zombies = []
        walls = []
        shots = []
        turrets = []
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
        
        //checks if the turret can shoot
        for turret in turrets {
            var shootPosition = turret.findClosestTarget(zombies: zombies)
            
            if(turret.canShoot)
            {
                if(shootPosition.x != 0 && shootPosition.y != 0)
                {
                    let newShot = Shot(direction: shootPosition)
                    addChild(newShot)
                    newShot.position =  turret.position
                    shots.append(newShot)
                    
                    turret.shoot()
                }
            }
        }
        //collision between the shots and zombie
        var toBeDeletedShots : [Int] = []
        for shot in shots {
            var shotHit = false
            for zombie in zombies {
                let collisionShot = zombie.collision(items: [shot]).first
                
                if let _ = collisionShot {
                    if(!shotHit)
                    {
                        zombie.takeDamge()
                        shot.removeFromParent()
                        toBeDeletedShots.append(shots.index(of: shot)!)
                        shotHit = true
                    }
                }
            }
        }
        deleteShots(toBeDeletedShots)
        
        
        
        
        
        var toBeDeletedZombies : [Int] = []
        for zombie in zombies {
            //makes sure zombie only attackes one wall at a time
            var zombieActionDone = false
            if (zombie.isDead)
            {
                if(zombie.type.health == 2)
                {
                    coins += 10
                    score += 1
                }
                if(zombie.type.health == 3)
                {
                    coins += 20
                    score += 2
                }
                if(zombie.type.health == 5)
                {
                    coins += 30
                    score += 3
                }
                
                zombie.removeFromParent()
                toBeDeletedZombies.append(zombies.index(of: zombie)!)
                zombieActionDone = true
            }
            
            
            var toBeDeletedWalls : [Int] = []
            //loops through all the walls to see if a zombie is colliding with any
             for wall in walls {
                let collisionWall = zombie.collision(items: [wall]).first
                
                if(!zombieActionDone)
                {
                    //if the walll health is below  removes the wall
                    if (wall.dead)
                    {
                        wall.removeFromParent()
                        toBeDeletedWalls.append(walls.index(of: wall)!)
                    }
                    //checks for collison between the wall and the turret
                    else if let _ = collisionWall {
                        //if the zombie is alreyd doing the attackanimation dont call it againe
                        if(zombie.attacking == false)
                        {
                            zombie.attackWall()
                        }
                        wall.takeDamge(damgeAmount: 2)
                        zombieActionDone = true
                    }
                    //if there is no collsion between the wall and the zombie but he is still attacking it stops him
                    else if(zombie.attacking)
                    {
                        zombie.walk()
                    }
                }
            }
            deleteWalls(toBeDeletedWalls)
            var toBeDeletedTurrets : [Int] = []
            for turret in turrets {
                let collisionTurret = zombie.collision(items: [turret]).first
                
                if(!zombieActionDone)
                {
                    //if the turret health is below  removes the turret
                    if (turret.dead)
                    {
                        turret.removeFromParent()
                        toBeDeletedTurrets.append(turrets.index(of: turret)!)
                    }
                        //checks for collison between the wall and the turret
                    else if let _ = collisionTurret {
                        //if the zombie is alreyd doing the attackanimation dont call it againe
                        if(zombie.attacking == false)
                        {
                            zombie.attackWall()
                        }
                        turret.takeDamge(damgeAmount: 2)
                        zombieActionDone = true
                    }
                        //if there is no collsion between the wall and the zombie but he is still attacking it stops him
                    else if(zombie.attacking)
                    {
                        zombie.walk()
                    }
                }
            }
            deleteTurrets(toBeDeletedTurrets)
            
            
            print(currentTime)
            if(walls.count == 0 && turrets.count == 0)
            {
                if(zombie.attacking)
                {
                    zombie.walk()
                }
            }
        }
        deleteZombies(toBeDeletedZombies)
        
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
            
            
            
            
            if(position.x >= self.position.x + 300-75 && position.x <= self.position.x + (300-75 + selectTurretImage.size.width) && position.y >= self.position.y && position.y <= self.position.y+200)
            {
                turretIsSelected = true
                wallIsSelected = false
            }
            else if(position.x >= self.position.x + 600-75 && position.x <= self.position.x + (600-75 + selectWallImage.size.width) && position.y >= self.position.y && position.y <= self.position.y+200)
            {
                wallIsSelected = true
                turretIsSelected = false
            }
            else if(wallIsSelected && coins > 49)
            {
                let newWall = Wall()
                addChild(newWall)
                newWall.position =  position
                walls.append(newWall)
                wallIsSelected = false
                coins -= 50
            }
            else if(turretIsSelected && coins > 99)
            {
                let newTurret = Turret()
                addChild(newTurret)
                newTurret.position =  position
                turrets.append(newTurret)
                turretIsSelected = false
                coins -= 100
            }
        }
    }
    
    
    private func deleteZombies(_ zombieIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = zombieIndexes.reversed()
        
        for index in reversedIndexes {
            zombies.remove(at: index)
        }
    }
    
    private func deleteWalls(_ wallIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = wallIndexes.reversed()
        
        for index in reversedIndexes {
            walls.remove(at: index)
        }
    }
    private func deleteShots(_ shotIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = shotIndexes.reversed()
        
        for index in reversedIndexes {
            shots.remove(at: index)
        }
    }
    private func deleteTurrets(_ turretIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = turretIndexes.reversed()
        
        for index in reversedIndexes {
            turrets.remove(at: index)
        }
    }
}

