//
//  ZombieSpawner.swift
//  FightTheDead
//
//  Created by Ahmad Muhammad Z. on 4/18/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class ZombieSpawner {
    
    weak var scene : SKScene?
    let spawnArea : CGRect
    let randMin : Double
    let randMax : Double
    
    private var startTime : TimeInterval?
    private var nextSpawnTime : TimeInterval?
    private let zombieFactory : ZombieFactory
    
    init(givenSpawnArea : CGRect, min : TimeInterval, max : TimeInterval) {
        randMin = min
        randMax = max
        zombieFactory = ZombieFactory()
        spawnArea = givenSpawnArea
        nextSpawnTime = random(min: randMin, max: randMax)
    }
    
    func update(time: TimeInterval) -> Zombie? {
        guard let scene = scene, let startTime = startTime, let nextSpawnTime = nextSpawnTime else {
            guard let _ = self.scene else {
                return nil
            }
            self.startTime = time;
            return nil;
        }
        let deltaTime = time - startTime;
        
        guard deltaTime > nextSpawnTime else {
            return nil
        }
        self.nextSpawnTime = nextSpawnTime + random(min: randMin, max: randMax);
        let myZombie = zombieFactory.makeZombie(zombieType: nil);
        
        myZombie.vel = CGPoint(x: -1,y: 0)
        
        scene.addChild(myZombie);
        myZombie.position = generateSpawnPosition()
        return myZombie
        
    }
    
    
    private func generateSpawnPosition() -> CGPoint {
        return CGPoint(x: random(min: Double(spawnArea.minX), max: Double(spawnArea.maxX)),
                       y: random(min: Double(spawnArea.minY), max: Double(spawnArea.maxY)))
    }
    
    private func random(min: TimeInterval, max: TimeInterval) -> Double {
        return Double(CGFloat.random(min: CGFloat(min), max: CGFloat(max)))
    }
}


