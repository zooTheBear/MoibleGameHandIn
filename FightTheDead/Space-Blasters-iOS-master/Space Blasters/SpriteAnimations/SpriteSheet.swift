//
//  SpriteSheet.swift
//  Space Blasters
//
//  Created by Irving Waisman on 2018-04-15.
//  Copyright © 2018 Irving Waisman. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteSheet {
    
    let texture: SKTexture
    let rows: Int
    let columns: Int
    var margin: CGFloat=0
    var spacing: CGFloat=0
    var frameSize: CGSize {
        return CGSize(width: (self.texture.size().width-(self.margin*2+self.spacing*CGFloat(self.columns-1)))/CGFloat(self.columns),
                      height: (self.texture.size().height-(self.margin*2+self.spacing*CGFloat(self.rows-1)))/CGFloat(self.rows))
    }
    
    init(texture: SKTexture, rows: Int, columns: Int, spacing: CGFloat, margin: CGFloat) {
        self.texture=texture
        self.rows=rows
        self.columns=columns
        self.spacing=spacing
        self.margin=margin
        
    }
    
    convenience init(texture: SKTexture, rows: Int, columns: Int) {
        self.init(texture: texture, rows: rows, columns: columns, spacing: 0, margin: 0)
    }
    
    func textureForColumn(column: Int, row: Int)->SKTexture? {
        if !(0...self.rows ~= row && 0...self.columns ~= column) {
            //location is out of bounds
            return nil
        }
        
        var textureRect=CGRect(x: self.margin+CGFloat(column)*(self.frameSize.width+self.spacing)-self.spacing,
                               y: self.margin+CGFloat(row)*(self.frameSize.width+self.spacing)-self.spacing,
                               width: self.frameSize.width,
                               height: self.frameSize.height)
        
        textureRect=CGRect(x: textureRect.origin.x/self.texture.size().width, y: textureRect.origin.y/self.texture.size().height,
                           width: textureRect.size.width/self.texture.size().width, height: textureRect.size.height/self.texture.size().height)
        return SKTexture(rect: textureRect, in: self.texture)
    }

}
