//
//  GameViewController.swift
//  bumplock
//
//  Created by Perris Davis on 1/13/16.
//  Copyright (c) 2016 Perris Davis. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameDelegate {
    
    var scene = GameScene()
    
    var continueMode: Bool?
    
    var newImage: UIImage?
    
    @IBAction func menuButtonHandler(sender: AnyObject) {
        scene.gameDelegate = nil

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIViewController.prepareInterstitialAds()
        self.interstitialPresentationPolicy = .Manual
        
        let scene = GameScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        if let continueIsTrue = continueMode {
            
            scene.continueMode = continueIsTrue
        }
        
        scene.gameDelegate = self
        
        skView.presentScene(scene)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func gameStarted() {
    }
    
    func gameFinished() {
        self.requestInterstitialAdPresentation()
    }
    
    func share(image: UIImage) {
        
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(avc, animated: true, completion: nil)
    }

}
