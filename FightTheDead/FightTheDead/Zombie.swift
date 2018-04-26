//
//  Zombie.swift
//
//  Created by Ahmad Muhammad Z. on 4/17/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.

import Foundation
import SpriteKit


/// A zombie Enum
enum ZombieType: UInt32 {
    //the three type of zombies
    case normal = 0
    case weak
    case strong
    //speed based on type of zombie
    var speed: CGFloat {
        switch self {
        case .weak:
            return 60.0
        case .normal:
            return 45.0
        case .strong:
            return 30.0
        }
    }
    //health based on the type of zombie
    var health: CGFloat {
        switch self {
        case .weak:
            return 2.0
        case .normal:
            return 3.0
        case .strong:
            return 5.0
        }
    }
}

extension Zombie {
    //the wait time per frame
    static let timePerFrame = 0.1
    
    struct Textures {
        static let defaultZombieImage = "zombie1"
    }
    
}

/// A zombie class
class Zombie: GameObject {
    //strongs zombie walking animation
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
    //normal zombie walking animation
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
     //weak zombie walking animation
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
     //normal zombie attacking animation
    let normalZombieAttackImage = [SKTexture(imageNamed: "nAttack_1"),
                           SKTexture(imageNamed: "nAttack_2"),
                           SKTexture(imageNamed: "nAttack_3"),
                           SKTexture(imageNamed: "nAttack_4"),
                           SKTexture(imageNamed: "nAttack_5"),
                           SKTexture(imageNamed: "nAttack_6"),
                           SKTexture(imageNamed: "nAttack_7"),
                           SKTexture(imageNamed: "nAttack_8")]
     //weak zombie attacking animation
    let weakZombieAttackImage = [SKTexture(imageNamed: "wAttack_1"),
                                 SKTexture(imageNamed: "wAttack_2"),
                                 SKTexture(imageNamed: "wAttack_3"),
                                 SKTexture(imageNamed: "wAttack_4"),
                                 SKTexture(imageNamed: "wAttack_5"),
                                 SKTexture(imageNamed: "wAttack_6"),
                                 SKTexture(imageNamed: "wAttack_7"),
                                 SKTexture(imageNamed: "wAttack_8")]
    //strong zombie attacking animation
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
        //starts the defualt walking animation based on its type
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
        //sets the size of the zombie
        self.size = CGSize(width: 75, height: 150)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //the default health of the zombie
    var myHealth = CGFloat(5)
    //sets to true if the zombie is dead
    var isDead = false
    //checks if the zombie health has been assinged based on its type
    var assingHealth = true
    
    override func update(_ currentTime: TimeInterval) {
        //assings the health based on the type of zombie its is
        if(assingHealth)
        {
            myHealth = type.health
            assingHealth = false
        }
        // calling super so we can use deltaTime recording in the super class
        super.update(currentTime)
        guard let direction = vel?.asUnitVector else {
            return
        }
        //if the zombie is not attacking it makes it move forward
        if(!attacking)
        {
            position = position.travel(in: direction, at: type.speed, for: deltaTime)
        }
        //if the health below 0 set the zombie to dead
        if(myHealth <= 0)
        {
            isDead = true
        }
    }
    
    //turns the animation of the zombie attacking based on what type it is
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
    //turns the animation of the zombie walking based on what type it is
    func walk(){
        
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
        attacking = false
    }
    //Reduces the health by 1
    func takeDamge(){
        self.myHealth -= 1
    }
    
    
    //when the player taps on the zombie, the health of the zombie is reduced byy 1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        takeDamge()
    }
    
}
