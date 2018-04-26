//
//  Wall.swift
//  TowerDefence
//
//  Created by Ahmad Muhammad Z. on 4/17/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class Wall : GameObject {
    //walls health
    var health: CGFloat = 400
    //sets to true if the wall is broken
    var dead = false
    init() {
        super.init(imageName: "wall1")
        name = "Wall"
        self.size = CGSize(width: 75, height: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //update fucntion
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard let scene = parent else {
            return
        }
        //if health is below 0 sets the wall to dead
        if(self.health <= 0)
        {
            self.dead = true
        }
    }
    //takes damge based on the argument
    func takeDamge(damgeAmount: CGFloat){
        self.health -= damgeAmount
    }
}

