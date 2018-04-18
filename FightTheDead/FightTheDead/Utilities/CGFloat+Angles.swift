//
//  CGFloat+Angles.swift
//  ZombieConga
//
//  Created by Kevin Kruusi on 2018-03-16.
//  Copyright © 2018 kevin. All rights reserved.
//

import SpriteKit

extension CGFloat {
    
    func toDegrees() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}
