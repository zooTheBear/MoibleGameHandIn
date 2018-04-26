//
//  Turret.swift
//  TowerDefence
//
//  Created by Ahmad Muhammad Z. on 4/17/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class Turret : GameObject {
    
    //the health of the turret
    var health: CGFloat = 100
    //the delay for the each shot
    var fireDelay: Double = 3.0
    //range of the turret
    var range: CGFloat = 1000
    //stores the time that gets used for the delay
    var storeTime: Double = 0.0
    //checks if the turret can shoot
    var canShoot = true
    //makes teh turret to wait before shooting
    var waitForNextShot = false
    //gets set to true
    var dead = false
    init() {
        super.init(imageName: "Turret")
        name = "Turret"
        self.size = CGSize(width: 150, height: 75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //update fucnction of the turret
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(!canShoot && !waitForNextShot)
        {
            storeTime = currentTime
            waitForNextShot = true
        }
        else if(currentTime > storeTime + fireDelay)
        {
            print("Shooting")
            canShoot = true
            waitForNextShot = false
        }
        
        
        guard let scene = parent else {
            return
        }
        if(self.health <= 0)
        {
            self.dead = true
        }
        
    }
    //finds the and returns the closest target to the turret
    func findClosestTarget(zombies: [Zombie])-> CGPoint
    {
        
        var closestZombie = CGFloat(10000)
        var closestPoint = CGPoint(x: 0, y: 0)
        
        for zombie in zombies {
            
            let xDist = self.position.x - zombie.position.x
            let yDist = self.position.y - zombie.position.y
            var distance = CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
            
            if(distance < range)
            {
                if(distance < closestZombie)
                {
                    closestZombie = distance
                    closestPoint = zombie.position
                }
            }
        }
        return closestPoint
    }
    //makes it so that the turret waits for delay before shooting againe
    func shoot()
    {
        canShoot = false
    }
    
    //Reduces the health of the zombie
    func takeDamge(damgeAmount: CGFloat){
        self.health -= damgeAmount
    }
}


