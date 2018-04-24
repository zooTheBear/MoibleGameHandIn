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
    
    static var health: CGFloat = 1
    var dead = false
    init() {
        super.init(imageName: "wall1")
        name = "cat"
        self.size = CGSize(width: 75, height: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard let scene = parent else {
            return
        }
        
        if(Wall.health < 0)
        {
            dead = true
        }
    }
}

