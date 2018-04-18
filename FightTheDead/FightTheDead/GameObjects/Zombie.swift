//
//  Zombie.swift
//  ZombieConga
//
//  Created by Ahmad Muhammad Z. on 4/17/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.

import Foundation
import SpriteKit


/// A zombie Enum
enum ZombieType: UInt32 {
    case normal = 0
    case weak
    case strong
    
    var speed: CGFloat {
        switch self {
        case .weak:
            return 20.0
        case .normal:
            return 15.0
        case .strong:
            return 10.0
        }
    }
}

// MARK: - Constants
extension Zombie {
    
    static let timePerFrame = 0.1
    static let waitTime = 5.0
    static let defaultTexture = "StrongZombie_1"
    
    struct Textures {
        //static let zombie1 = "zombie1"
        //static let zombie2 = "zombie2"
        //static let zombie3 = "zombie3"
    }
}

/// A zombie class
class Zombie: GameObject {
    
    let normalZombieImage = [SKTexture(imageNamed: "StrongZombie_1"),
                             SKTexture(imageNamed: "StrongZombie_2"),
                             SKTexture(imageNamed: "StrongZombie_3"),
                             SKTexture(imageNamed: "StrongZombie_4"),
                             SKTexture(imageNamed: "StrongZombie_5"),
                             SKTexture(imageNamed: "StrongZombie_6"),
                             SKTexture(imageNamed: "StrongZombie_7"),
                             SKTexture(imageNamed: "StrongZombie_8"),
                             SKTexture(imageNamed: "StrongZombie_9"),
                             SKTexture(imageNamed: "StrongZombie_10"),]
    
    /*let weakZombieImage = [SKTexture(imageNamed: "weakZombie1"),
                             SKTexture(imageNamed: "weakZombie2"),
                             SKTexture(imageNamed: "weakZombie3")]
    
    let strongZombieImage = [SKTexture(imageNamed: "strongZombie1"),
                             SKTexture(imageNamed: "strongZombie2"),
                             SKTexture(imageNamed: "strongZombie3")]*/
    
    
    let type: ZombieType
    var vel : CGPoint?
    
    init(type: ZombieType) {
        self.type = type
        super.init(imageName: Zombie.defaultTexture)
        isUserInteractionEnabled = true
        
        if(self.type == ZombieType.weak)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: normalZombieImage, timePerFrame: Zombie.timePerFrame)))
        }
        else if(self.type == ZombieType.strong)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: normalZombieImage, timePerFrame: Zombie.timePerFrame)))
        }
        else
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: normalZombieImage, timePerFrame: Zombie.timePerFrame)))
        }
        
        self.size = CGSize(width: 50, height: 100)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // calling super so we can use deltaTime recording in the super class
        super.update(currentTime)
        guard let direction = vel?.asUnitVector else {
            return
        }
            position = position.travel(in: direction, at: type.speed, for: deltaTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}
