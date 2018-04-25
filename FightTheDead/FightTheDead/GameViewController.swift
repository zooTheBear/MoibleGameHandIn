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

//import GoogleMobileAds

class GameViewController  : UIViewController  {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //var adBanner: GADBannerView!
        
       // adBanner = GADBannerView(adSize:kGADAdSizeBanner)
        
        /*//banner id
        adBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBanner.rootViewController = self
        addBannerViewToView(adBanner)
        
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)*/
        
        let theGameScene : GameScene = GameScene(size: CGSize(width: 1600, height: 1200))
        view = SKView(frame: view.frame)
        let skView = self.view as! SKView
        skView.presentScene(theGameScene)
    }
    
    /*func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([NSLayoutConstraint(item: bannerView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: bottomLayoutGuide,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: bannerView,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0)])
    }*/
    
}

