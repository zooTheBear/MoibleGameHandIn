//
//  ZombieGame2ViewController.swift
//  ZombieConga
//
//  Created by Kevin Kruusi on 2018-03-08.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import SceneKit

class GameViewController  : UIViewController  {
    override func viewDidLoad() {
        super.viewDidLoad()
        let theGameScene : GameScene = GameScene(size: CGSize(width: 1600, height: 1200))
        view = SKView(frame: view.frame)
        let skView = self.view as! SKView
        skView.presentScene(theGameScene)
    }
}

