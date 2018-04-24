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
    
    let strongZombieImage = [SKTexture(imageNamed: "StrongZombie_1"),
                             SKTexture(imageNamed: "StrongZombie_2"),
                             SKTexture(imageNamed: "StrongZombie_3"),
                             SKTexture(imageNamed: "StrongZombie_4"),
                             SKTexture(imageNamed: "StrongZombie_5"),
                             SKTexture(imageNamed: "StrongZombie_6"),
                             SKTexture(imageNamed: "StrongZombie_7"),
                             SKTexture(imageNamed: "StrongZombie_8"),
                             SKTexture(imageNamed: "StrongZombie_9"),
                             SKTexture(imageNamed: "StrongZombie_10"),]
    
    let normalZombieImage = [SKTexture(imageNamed: "NormalZombie_1"),
                             SKTexture(imageNamed: "NormalZombie_2"),
                             SKTexture(imageNamed: "NormalZombie_3"),
                             SKTexture(imageNamed: "NormalZombie_4"),
                             SKTexture(imageNamed: "NormalZombie_5"),
                             SKTexture(imageNamed: "NormalZombie_6"),
                             SKTexture(imageNamed: "NormalZombie_7"),
                             SKTexture(imageNamed: "NormalZombie_8"),
                             SKTexture(imageNamed: "NormalZombie_9"),
                             SKTexture(imageNamed: "NormalZombie_10")]
    
    let weakZombieImage = [SKTexture(imageNamed: "WeakZombie_1"),
                             SKTexture(imageNamed: "WeakZombie_2"),
                             SKTexture(imageNamed: "WeakZombie_3"),
                             SKTexture(imageNamed: "WeakZombie_4"),
                             SKTexture(imageNamed: "WeakZombie_5"),
                             SKTexture(imageNamed: "WeakZombie_6"),
                             SKTexture(imageNamed: "WeakZombie_7"),
                             SKTexture(imageNamed: "WeakZombie_8"),
                             SKTexture(imageNamed: "WeakZombie_9"),
                             SKTexture(imageNamed: "WeakZombie_10")]
    
    let normalZombieAttackImage = [SKTexture(imageNamed: "nAttack_1"),
                           SKTexture(imageNamed: "nAttack_2"),
                           SKTexture(imageNamed: "nAttack_3"),
                           SKTexture(imageNamed: "nAttack_4"),
                           SKTexture(imageNamed: "nAttack_5"),
                           SKTexture(imageNamed: "nAttack_6"),
                           SKTexture(imageNamed: "nAttack_7"),
                           SKTexture(imageNamed: "nAttack_8")]
    
    let weakZombieAttackImage = [SKTexture(imageNamed: "wAttack_1"),
                                 SKTexture(imageNamed: "wAttack_2"),
                                 SKTexture(imageNamed: "wAttack_3"),
                                 SKTexture(imageNamed: "wAttack_4"),
                                 SKTexture(imageNamed: "wAttack_5"),
                                 SKTexture(imageNamed: "wAttack_6"),
                                 SKTexture(imageNamed: "wAttack_7"),
                                 SKTexture(imageNamed: "wAttack_8")]
    
    let strongZombieAttackImage = [SKTexture(imageNamed: "sAttack_1"),
                                 SKTexture(imageNamed: "sAttack_2"),
                                 SKTexture(imageNamed: "sAttack_3"),
                                 SKTexture(imageNamed: "sAttack_4"),
                                 SKTexture(imageNamed: "sAttack_5"),
                                 SKTexture(imageNamed: "sAttack_6"),
                                 SKTexture(imageNamed: "sAttack_7")]
    
    
    
    
    
    let type: ZombieType
    
    var attacking = false
    
    var vel : CGPoint?
    init(type: ZombieType) {
        self.type = type
        super.init(imageName: Zombie.defaultTexture)
        isUserInteractionEnabled = true
        
        if(self.type == ZombieType.weak)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: weakZombieImage, timePerFrame: Zombie.timePerFrame)))
            
        }
        else if(self.type == ZombieType.strong)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: strongZombieImage, timePerFrame: Zombie.timePerFrame)))
        }
        else
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: normalZombieImage, timePerFrame: Zombie.timePerFrame)))
        }
        
        self.size = CGSize(width: 75, height: 150)
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
        
        if(!attacking)
        {
            position = position.travel(in: direction, at: type.speed, for: deltaTime)
        }
    }
    
    
    func attackWall(){
        
        if(self.type == ZombieType.weak)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: weakZombieAttackImage, timePerFrame: Zombie.timePerFrame)))
            
        }
        else if(self.type == ZombieType.strong)
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: strongZombieAttackImage, timePerFrame: Zombie.timePerFrame)))
        }
        else
        {
            self.run(SKAction.repeatForever(SKAction.animate(with: normalZombieAttackImage, timePerFrame: Zombie.timePerFrame)))
        }
        attacking = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        attackWall()
    }
    
}
