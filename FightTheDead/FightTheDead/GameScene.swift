//
//  GameScene.swift
//  FightTheDead
//
//  Created by Ahmad Muhammad Z. on 4/18/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import SpriteKit
import GameplayKit
//global variables
var finalScore = 0
var finalWave = 0

class GameScene: SKScene {
    
    //for the score, coins and player health
    var coinLabel: SKLabelNode!
    var scoreLable: SKLabelNode!
    var healthLable: SKLabelNode!
    //at the start the player has 100 coins
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
    //player starts with 100 health
    var health = 3 {
        didSet {
            healthLable.text = "Health: \(health)"
        }
    }
    
    var zombiesAlive = 0
    var maxZombiesToSpawn = 0
    var zombiesSpawned = 0
    var nextWaveCalled = false
    
    
    private var spawnManager: ZombieSpawner?
    private var zombies: [Zombie] = []
    private var walls: [Wall] = []
    private var turrets: [Turret] = []
    private var shots: [Shot] = []
    //private var turrets: [Turret] = []
    private let background = SKSpriteNode(imageNamed: "background1")
    private let selectWallImage = SKSpriteNode(imageNamed: "wallSelect")
    private let selectTurretImage = SKSpriteNode(imageNamed: "FinalTurretSelect")
    
    let rocketFireSound = SKAction.playSoundFileNamed("rocketSound.wav", waitForCompletion: false)
    
    var turretIsSelected = false
    var wallIsSelected = false
    
    //level setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        spawnManager = ZombieSpawner(givenSpawnArea: CGRect(x: self.size.width + 10 , y: 200, width: 100, height: self.size.height-200), min: 1, max: 4);
        //resets the score and wave
        finalScore = 0
        finalWave = 0
        
        spawnManager?.scene = self
        backgroundColor = SKColor.black
        background.zPosition = -1
        background.size = self.size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        //adds the image of slectable turret to the scene
        selectTurretImage.zPosition = 0
        selectTurretImage.size = CGSize(width: 150, height: 75)
        selectTurretImage.position = CGPoint(x: 300, y: 100)
        //adds the image of slectable wall to the scene
        selectWallImage.zPosition = 0
        selectWallImage.size = CGSize(width: 150, height: 75)
        selectWallImage.position = CGPoint(x: 600, y: 100)
        //displays the coins of the player
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel.text = "Coins: 100"
        coinLabel.horizontalAlignmentMode = .right
        coinLabel.position = CGPoint(x: self.position.x+200, y: self.size.height-100)
        //displays the score of the player
        scoreLable = SKLabelNode(fontNamed: "Chalkduster")
        scoreLable.text = "Score: 0"
        scoreLable.horizontalAlignmentMode = .right
        scoreLable.position = CGPoint(x: self.size.width/2, y: self.size.height-100)
        //displays the health of the player
        healthLable = SKLabelNode(fontNamed: "Chalkduster")
        healthLable.text = "Health: 3"
        healthLable.horizontalAlignmentMode = .right
        healthLable.position = CGPoint(x: self.size.width - 300, y: self.size.height-100)
        
        
        addChild(scoreLable)
        addChild(coinLabel)
        addChild(healthLable)
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
        
        // calling update on all of the game objects
        for gameObject in gameObjects {
            gameObject?.update(currentTime)
        }
        
        // Collision detection and cleanup
        
        //checks if the turret can shoot
        //if it can its looks for the cloesest zombie and shoots towards it
        for turret in turrets {
            //finds the closest zombie
            var shootPosition = turret.findClosestTarget(zombies: zombies)
            
            if(turret.canShoot)
            {
                if(shootPosition.x != 0 && shootPosition.y != 0)
                {
                    //creates a new rocket
                    let newShot = Shot(direction: shootPosition)
                    //adds the rocket to the scene
                    addChild(newShot)
                    //sets the rocket position to the turret position
                    newShot.position =  turret.position
                    //adds the rocket to the shots array
                    shots.append(newShot)
                    //lets the turret know that it shot
                    turret.shoot()
                }
            }
        }
        //collision between the shots and zombie
        //if there is collsion between the 2 it deletes the rocket and applies damge to the zombie
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
        
        
        
        
        //list of zombies that need to be deleted
        var toBeDeletedZombies : [Int] = []
        //checks each zombie in the array
        for zombie in zombies {
            //makes sure zombie only attackes one wall at a time
            var zombieActionDone = false
            //checks if the zombie is dead
            if (zombie.isDead)
            {
                //if a zombie is killed it awards the player based on the type of the zombie
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
                //removes the zombie
                zombie.removeFromParent()
                toBeDeletedZombies.append(zombies.index(of: zombie)!)
                zombieActionDone = true
                finalScore = score
            }
            //checks if any zombie made it through and if they did it deletes the zombie and reduces the playes health
            if(zombie.position.x < 0)
            {
                health -= 1
                zombie.removeFromParent()
                toBeDeletedZombies.append(zombies.index(of: zombie)!)
                zombieActionDone = true
                
                if(health < 1)
                {
                    //calls the death scene if the player is dead
                    let callScene = GameOverScene(size: self.size) // make sure game scene is the same size
                    callScene.scaleMode = self.scaleMode // same goes for the scale
                    let sceneTransition = SKTransition.fade(withDuration: 0.5) // transition to scene in set duration
                    self.view!.presentScene(callScene, transition: sceneTransition) // call scene
                }
            }
            
            
            var toBeDeletedWalls : [Int] = []
            //loops through all the walls to see if a zombie is colliding with any
             for wall in walls {
                 //checks if a zombie is collding with a wall
                let collisionWall = zombie.collision(items: [wall]).first
                
                if(!zombieActionDone)
                {
                    //if the walll health is below  removes the wall
                    if (wall.dead)
                    {
                        let deathFireEffect = Bundle.main.path(forResource: "MyParticle", ofType: "sks")!
                        let deathFire = NSKeyedUnarchiver.unarchiveObject(withFile: deathFireEffect) as! SKEmitterNode
                        deathFire.xScale = 5
                        deathFire.yScale = 5
                        deathFire.position.y = wall.position.y
                        deathFire.position.x = wall.position.x
                        deathFire.zPosition = 1
                        self.addChild(deathFire)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            deathFire.removeFromParent()
                        }
                        wall.removeFromParent()
                        toBeDeletedWalls.append(walls.index(of: wall)!)
                    }
                    //checks for collison between the wall and the turret
                    //if there is collsion it makes the zombie attack the wall
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
            //calls the delete walls funtion
            deleteWalls(toBeDeletedWalls)
            var toBeDeletedTurrets : [Int] = []
            //goes through each turret and compares it to the zombie to see if they are colliding
            for turret in turrets {
                //compares a zombie to a turret to see if they are colliding
                let collisionTurret = zombie.collision(items: [turret]).first
                
                if(!zombieActionDone)
                {
                    //if the turret health is below  removes the turret
                    //if the turret is dead it removes it from the scene
                    if (turret.dead)
                    {
                        let deathFireEffect = Bundle.main.path(forResource: "MyParticle", ofType: "sks")!
                        let deathFire = NSKeyedUnarchiver.unarchiveObject(withFile: deathFireEffect) as! SKEmitterNode
                        deathFire.xScale = 5
                        deathFire.yScale = 5
                        deathFire.position.y = turret.position.y
                        deathFire.position.x = turret.position.x
                        deathFire.zPosition = 1
                        self.addChild(deathFire)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            deathFire.removeFromParent()
                        }
                        turret.removeFromParent()
                        toBeDeletedTurrets.append(turrets.index(of: turret)!)
                    }
                    //checks for collison between the turret and the zombie
                    //if there is collsion it makes the zombie attack the turret
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
            //calls the delete turret fucntion
            deleteTurrets(toBeDeletedTurrets)
            
            
            print(currentTime)
            //this is used to avoid a bug 
            //makes the zombie walk forward if there are no turrets or walls on the screen
            if(walls.count == 0 && turrets.count == 0)
            {
                if(zombie.attacking)
                {
                    zombie.walk()
                }
            }
        }
        //calls the delete zombie fucntion
        deleteZombies(toBeDeletedZombies)
        
        //spawns a zombie at a randome location within the rectangle specified
        if(zombies.count == 0 && !nextWaveCalled)
        {
            nextWave();
            nextWaveCalled = true
        }
        
        if(zombiesSpawned != maxZombiesToSpawn)
        {
            let tempCounter = zombies.count
            guard let zombie = spawnManager?.update(time: currentTime) else {
                return
            }
            //adds the zombie to the array
            zombies.append(zombie)
            //this is to make sure a zombie was spawned
            if(tempCounter < zombies.count)
            {
                zombiesSpawned += 1
            }
        }
        else
        {
            nextWaveCalled = false
        }
    }
    
    //on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let position = touch.location(in: self)
            
            
            
            //if the tap happened on top of turret slectable sets the turret as select item to be placed down
            if(position.x >= self.position.x + 300-75 && position.x <= self.position.x + (300-75 + selectTurretImage.size.width) && position.y >= self.position.y && position.y <= self.position.y+200)
            {
                turretIsSelected = true
                wallIsSelected = false
            }
            //if the tap happened on top of wall slectable sets the wall as select item to be placed down
            else if(position.x >= self.position.x + 600-75 && position.x <= self.position.x + (600-75 + selectWallImage.size.width) && position.y >= self.position.y && position.y <= self.position.y+200)
            {
                wallIsSelected = true
                turretIsSelected = false
            }
            //checks if the player has enough coins and if he does palces the wall on to the screen
            else if(wallIsSelected && coins > 49)
            {
                //makes a new wall
                let newWall = Wall()
                //adds the wall to the scene
                addChild(newWall)
                //sets the position the tap position
                newWall.position =  position
                //adds the wall to the array of walls
                walls.append(newWall)
                //sets the slectables to false
                wallIsSelected = false
                //takes 50 coins from the player
                coins -= 50
            }
            //checks if the player has enough coins and if he does palces the turret on to the screen
            else if(turretIsSelected && coins > 99)
            {
                //makes a new turret
                let newTurret = Turret()
                //adds teh turret to the scene
                addChild(newTurret)
                //sets the location of the turret to the position of the tap
                newTurret.position =  position
                //adds the new turret to the array
                turrets.append(newTurret)
                //sets the selected item to false
                turretIsSelected = false
                //takes 100 coins from the player
                coins -= 100
            }
            //if the player dosnt have enough coins sets his select choice to false
            else
            {
                turretIsSelected = false
                wallIsSelected = false
            }
        }
    }
    
    //sets the variables for the next wave
    private func nextWave() {
        
        maxZombiesToSpawn += 3
        zombiesSpawned = 0
        finalWave += 1
        
        let nextWaveTest = SKLabelNode(fontNamed: "Chalkduster")
        nextWaveTest.text = "Wave \(finalWave)"
        nextWaveTest.fontSize = 125
        nextWaveTest.fontColor = SKColor.white
        nextWaveTest.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        nextWaveTest.zPosition = 1
        self.addChild(nextWaveTest)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            nextWaveTest.removeFromParent()
        }
    }
    //deletes the zombies from the zombie array
    private func deleteZombies(_ zombieIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = zombieIndexes.reversed()
        
        for index in reversedIndexes {
            zombies.remove(at: index)
        }
    }
    //deletes the walls from the wall array
    private func deleteWalls(_ wallIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = wallIndexes.reversed()
        
        for index in reversedIndexes {
            walls.remove(at: index)
        }
    }
    //deletes shots from the shots array
    private func deleteShots(_ shotIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = shotIndexes.reversed()
        
        for index in reversedIndexes {
            shots.remove(at: index)
        }
    }
    //deletes the turrets from the turret array
    private func deleteTurrets(_ turretIndexes: [Int]) {
        
        // flip the index order to remove the later before the lower index
        let reversedIndexes = turretIndexes.reversed()
        
        for index in reversedIndexes {
            turrets.remove(at: index)
        }
    }
}

