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
    
    // Genrates a randome number between 1 and 3 and chose the zombie based on that
    private func randomZombie() -> Zombie {
        let rand: UInt32 = arc4random() % 3
        let zombieType = ZombieType(rawValue: rand)
        return Zombie(type: zombieType!)
    }
}

