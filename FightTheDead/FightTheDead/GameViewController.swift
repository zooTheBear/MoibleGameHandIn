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
import AVFoundation
import GoogleMobileAds

class GameViewController  : UIViewController  {
    var backgroundMusic = AVAudioPlayer()
    var adBanner: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Find music to laod correctly
        let filePathForBackgroundMusic = Bundle.main.path(forResource: "music", ofType: "mp3")
        let audioNSURL = NSURL(fileURLWithPath: filePathForBackgroundMusic!)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: audioNSURL as URL)
        } catch {
            return print("Audio not FOUND!")
        }
        backgroundMusic.numberOfLoops = -1 // loop bakcground music forever
        backgroundMusic.play() // play background music
        
        adBanner = GADBannerView(adSize:kGADAdSizeBanner)
        //banner test id
        adBanner.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        adBanner.rootViewController = self
        addBannerViewToView(adBanner)
            
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
        
        let theGameScene : MainMenuScene = MainMenuScene(size: CGSize(width: 1600, height: 1200))
        view = SKView(frame: view.frame)
        let skView = self.view as! SKView
        skView.presentScene(theGameScene)
}
    func addBannerViewToView(_ bannerView: GADBannerView){
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
    }
}
