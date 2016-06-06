//
//  GameScene.swift
//  sinnerbro
//
//  Created by Perris Davis on 1/11/16.
//  Copyright (c) 2016 Perris Davis. All rights reserved.
//

import SpriteKit
import iAd

protocol GameDelegate {
    
    func gameStarted()
    func gameFinished()
}

class GameScene: SKScene {
    
    var gameDelegate: GameDelegate?
    
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var dot = SKShapeNode()
    
    var path = UIBezierPath()
    
    let zeroAngle: CGFloat = 0.0
    
    var clockwise = Bool()
    var continueMode = Bool()
    
    var maxLevel = NSUserDefaults.standardUserDefaults().integerForKey("maxLevel")
    
    var started = false
    var touches = false
    
    var level = 1
    var dots = 0
    
    var levelLabel = SKLabelNode()
    var currentScoreLabel = SKLabelNode()
    
    func layoutGame() {
        
        backgroundColor = SKColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        if level > maxLevel {
            
            NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "maxLevel")
        }
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(M_PI*2), clockwise: true)
        
        lock = SKShapeNode(path: path.CGPath)
        lock.strokeColor = SKColor.grayColor()
        lock.lineWidth = 40.0
        self.addChild(lock)
        
        needle = SKShapeNode(rectOfSize: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.whiteColor()
        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120.0)
        needle.zRotation = 3.14/2
        needle.zPosition = 2.0
        self.addChild(needle)
        
        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        levelLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/3)
        levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 248.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        levelLabel.text = "Level \(level)"
        
        currentScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        currentScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 248.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        currentScoreLabel.text = "tap to begin"
        
        self.addChild(levelLabel)
        self.addChild(currentScoreLabel)
        
        newDot()
        userInteractionEnabled = true
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        if continueMode {
            
            level = maxLevel
        }
        layoutGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if !started {
            gameDelegate?.gameStarted()
            currentScoreLabel.text = "\(level - dots)"
            runClockwise()
            started = true
            clockwise = true
        } else {
            
            dotTouched()
        }
    }
    
    func runClockwise() {
        
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI*2), clockwise: true)
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        needle.runAction(SKAction.repeatActionForever(run).reversedAction())
    }
    
    func runCounterClockwise() {
        
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI*2), clockwise: true)
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        needle.runAction(SKAction.repeatActionForever(run))
    }
    
    func dotTouched() {
        
        if touches == true {
            
            touches = false
            dots++
            updateLabel()
            if  dots >= level {
                started = false
                completed()
                return
            }
            dot.removeFromParent()
            newDot()
            if clockwise {
                
                runCounterClockwise()
                clockwise = false
            } else {
                
                runClockwise()
                clockwise = true
            }
        } else {
            
            started = false
            touches = false
            
            gameOver()
            
        }
    }
    
    func updateLabel() {
        
        currentScoreLabel.text = "\(level - dots)"
    }
    
    func newDot() {
        
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 231.0/255.0, green: 150.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clearColor()
        
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        let radian = atan2(dy, dx)
        
        if clockwise {
            
            let tempAngle = CGFloat.random(radian + 1.0, max: radian + 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI*2), clockwise: true)
            dot.position = tempPath.currentPoint
        } else {
            
            let tempAngle = CGFloat.random(radian - 1.0, max: radian - 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI*2), clockwise: true)
            dot.position = tempPath.currentPoint
        }
        
        self.addChild(dot)
    }
    
    func completed() {
        userInteractionEnabled = false
        needle.removeFromParent()
        currentScoreLabel.text = "Won!"
        let actionRed = SKAction.colorizeWithColor(UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.waitForDuration(0.5)
        self.scene?.runAction(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.level++
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })
    }
    
    func gameOver() {
        userInteractionEnabled = false
        needle.removeFromParent()
        currentScoreLabel.text = "Fail!"
        let actionRed = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.waitForDuration(0.5)
        self.scene?.runAction(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if started {
            
            if needle.intersectsNode(dot) {
                
                touches = true
            } else {
                
                if touches == true {
                    
                    if !needle.intersectsNode(dot) {
                        
                        started = false
                        touches = false
                        gameOver()
                    }
                }
            }
        }
    }
}
