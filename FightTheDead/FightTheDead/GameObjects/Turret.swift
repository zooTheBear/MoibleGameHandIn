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
    
    var health: CGFloat = 100
    var fireDelay: Double = 3.0
    var range: CGFloat = 1000
    var storeTime: Double = 0.0
    var canShoot = true
    var waitForNextShot = false
    var dead = false
    init() {
        super.init(imageName: "Turret")
        name = "Turret"
        self.size = CGSize(width: 150, height: 75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    func shoot()
    {
        canShoot = false
    }
    
    
    func takeDamge(damgeAmount: CGFloat){
        self.health -= damgeAmount
    }
    func shoot(damgeAmount: CGFloat){
        self.health -= damgeAmount
    }
    func findClosestTarget(damgeAmount: CGFloat){
        self.health -= damgeAmount
    }
}


