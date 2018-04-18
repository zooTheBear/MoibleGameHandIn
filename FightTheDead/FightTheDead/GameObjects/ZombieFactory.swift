//
//  ZombieFactory.swift
//  ZombieConga
//
//  Created by Ahmad Muhammad Z. on 4/17/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

/// Creates zombies
class ZombieFactory {
    func makeZombie(zombieType: ZombieType?) -> Zombie {
        
        guard let zombieType = zombieType else {
            
            return randomZombie()
        }
        
        return Zombie(type: zombieType)
    }
    
    // creates a random zombie
    private func randomZombie() -> Zombie {
        let rand: UInt32 = arc4random() % 3
        let zombieType = ZombieType(rawValue: rand)
        return Zombie(type: zombieType!)
    }
}

