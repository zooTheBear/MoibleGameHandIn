//
//  Shot.swift
//  FightTheDead
//
//  Created by Ahmad Muhammad Z. on 4/25/18.
//  Copyright © 2018 Ahmad Muhammad Z. All rights reserved.
//

import Foundation
import SpriteKit

class Shot : GameObject {
    
    var vel = CGPoint(x: 10, y: 10)
    var shotSpeed = CGFloat(10)
    public let direction: CGPoint
    
    
    init(direction: CGPoint) {
        self.direction = direction
        super.init(imageName: "Shot")
        name = "Shot"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        
        let dx = direction.x - self.position.x
        let dy = direction.y - self.position.y
        let angle = atan2(dy, dx)
        self.zRotation = angle
        
        let vx = cos(angle) * self.shotSpeed
        let vy = sin(angle) * self.shotSpeed
        
        self.position.x += vx
        self.position.y += vy
        
        
        
        
        //position = position.travel(in: sss, at: 700, for: deltaTime)
        guard let scene = parent else {
            return
        }
        
        if !scene.frame.contains(position) {
            cleanUp()
        }
    }
}
