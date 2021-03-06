//
//  GameScene.swift
//  ReflexDuel
//
//  Created by enzo bot on 1/2/17.
//  Copyright © 2017 madJOKERstudios. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum GameSceneState {
        case Ready, Strike, GameOver, StrikeTempo, AllOut, Fight, BeginTempo
    }
    
    var gameState: GameSceneState = .Ready

    var tapGesture:UITapGestureRecognizer!
    
    let background = SKSpriteNode(imageNamed: "background")
    var player1 = SKSpriteNode(imageNamed: "player1a")
    var player2 = SKSpriteNode(imageNamed: "player2a")
    let fightRing = SKSpriteNode(imageNamed: "fightRing")
    let player1StrikeBar = SKSpriteNode(imageNamed: "strikeBar")
    let player2StrikeBar = SKSpriteNode(imageNamed: "strikeBar")
    let player1StrikeTempo = SKSpriteNode(imageNamed: "strikeTempo")
    let player2StrikeTempo = SKSpriteNode(imageNamed: "strikeTempo")
    let player1StrikeEmitter = SKEmitterNode(fileNamed: "strikeParticle.sks")
    let player2StrikeEmitter = SKEmitterNode(fileNamed: "strikeParticle.sks")
    let strike1A = SKSpriteNode(imageNamed: "strike1")
    let strike1B = SKSpriteNode(imageNamed: "strike1")
    let strike2A = SKSpriteNode(imageNamed: "strike2")
    let strike2B = SKSpriteNode(imageNamed: "strike2")
    let strike3A = SKSpriteNode(imageNamed: "strike3")
    let strike3B = SKSpriteNode(imageNamed: "strike3")
    let critStrikeLineA = SKSpriteNode(imageNamed: "critStrikeLine")
    let critStrikeLineB = SKSpriteNode(imageNamed: "critStrikeLine")
    let strike1b = SKSpriteNode(imageNamed: "strike1")

    let readyButton1 = ButtonNode(activeImageNamed: "readyButton1", selectedImageNamed: "readyButton1", hiddenImageNamed: "readyButton1", litImageNamed: "readyButton1")
    let readyButton2 = ButtonNode(activeImageNamed: "readyButton2", selectedImageNamed: "readyButton2", hiddenImageNamed: "readyButton2", litImageNamed: "readyButton2")
    let retryButton = ButtonNode(activeImageNamed: "Again?", selectedImageNamed: "Again?", hiddenImageNamed: "Again?", litImageNamed: "Again?")
    
    var readyButton1Pressed: Bool = false
    var readyButton2Pressed: Bool = false
    var player1Tapped: Bool = false
    var player2Tapped: Bool = false
    var fightStart: Bool = false
    var player1HasTime: Bool = false
    var player2HasTime: Bool = false
    var timeFlag: Bool = false
    var gameOver: Bool = false
    var allOutModeEnabled: Bool = false
    var player1FalseStartCheck: Bool = false
    var player2FalseStartCheck: Bool = false
    var strikeEngaged: Bool = false
    var player1CanHit: Bool = false
    var player2CanHit: Bool = false
    var player1CanCrit: Bool = false
    var player2CanCrit: Bool = false
    var player1Hit: Bool = false
    var player2Hit: Bool = false
    var player1Crit: Bool = false
    var player2Crit: Bool = false
    var hasMissed1: Bool = false
    var hasMissed2: Bool = false

    
    var roundCounter: Int = 0
    var randStrike: Int = 0
    var time: Double = 0.0
    var startTime: Double = 0.0
    var randomTempoTimer: Double = 0.0
    weak var timer: Timer?
    var player1Time: Double = 0.0
    var player2Time: Double = 0.0
    var tappedTime: Double = 0.0
    var allOutCountDown: CFTimeInterval = 6
    var retryCountDown: CFTimeInterval = 3
    var tempoTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1/60 //60fps
    let wait1sec = SKAction.wait(forDuration: 2.0)
    
    var player1TimeLabelNode = SKLabelNode()
    var player2TimeLabelNode = SKLabelNode()
    var player1TimeLabelNodeB = SKLabelNode()
    var player2TimeLabelNodeB = SKLabelNode()
    var allOutCountDownLabel = SKLabelNode()
    var player2TapLabelNode = SKLabelNode()
    var player1TapLabelNode = SKLabelNode()
    
    let prepareLabel = SKSpriteNode(imageNamed: "prepareLabel")
    let toLabel = SKSpriteNode(imageNamed: "toLabel")
    let fightLabel = SKSpriteNode(imageNamed: "fightLabel")
    let youWinLabel = SKSpriteNode(imageNamed: "youWinLabel")
    let youLoseLabel = SKSpriteNode(imageNamed: "youLoseLabel")
    let drawLabel1 = SKSpriteNode(imageNamed: "drawLabel")
    let drawLabel2 = SKSpriteNode(imageNamed: "drawLabel")
    let tapLabel1 = SKSpriteNode(imageNamed: "tapLabel")
    let tapLabel2 = SKSpriteNode(imageNamed: "tapLabel")
    let waitLabel1 = SKSpriteNode(imageNamed: "waitLabel")
    let waitLabel2 = SKSpriteNode(imageNamed: "waitLabel")
    let nowLabel1 = SKSpriteNode(imageNamed: "nowLabel")
    let nowLabel2 = SKSpriteNode(imageNamed: "nowLabel")
    let missLabel1 = SKSpriteNode(imageNamed: "missLabel")
    let missLabel2 = SKSpriteNode(imageNamed: "missLabel")
    let tapOnFightLabel1 = SKSpriteNode(imageNamed: "tapOnFightLabel")
    let tapOnFightLabel2 = SKSpriteNode(imageNamed: "tapOnFightLabel")

    
    let white = SKSpriteNode(imageNamed: "White")
    let black = SKSpriteNode(imageNamed: "Black")

    var player1TapCount: Int = 0
    var player2TapCount: Int = 0
    
    let player1TapArea = TapButtonNode(activeImageNamed: "playerTapArea",
                                       tappedImageNamed: "playerTapArea",
                                       hiddenImageNamed: "playerTapArea",
                                       litImageNamed: "playerTapArea")
    let player2TapArea = TapButtonNode(activeImageNamed: "playerTapArea",
                                       tappedImageNamed: "playerTapArea",
                                       hiddenImageNamed: "playerTapArea",
                                       litImageNamed: "playerTapArea")
    //-----------------------------------------------------------------------------------
    //MARK: Animations
    func TapAttackPulse(){
        let p1 = SKTexture(imageNamed: "tapLabel")
        let p2 = SKTexture(imageNamed: "tapSmall")
        
        let textures = [p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2, p1, p2]
        
        let tapAnimation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: true)
        self.tapLabel1.run(tapAnimation)
        self.tapLabel2.run(tapAnimation)
    }
    //white strike animation
    func player1Strike(){
        let s1 = SKTexture(imageNamed: "player1b")
        let s2 = SKTexture(imageNamed: "player1c")
        let s3 = SKTexture(imageNamed: "player1d")
        let s4 = SKTexture(imageNamed: "player1e")
        let s5 = SKTexture(imageNamed: "player1d")
        let s6 = SKTexture(imageNamed: "player1c")
        let s7 = SKTexture(imageNamed: "player1b")
        let s8 = SKTexture(imageNamed: "player1a")
        
        let textures = [s1, s2, s3, s4, s5, s6, s7, s8]
        
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player1.run(strikeAnimation)
    }
    //black strike animation
    func player2Strike(){
        let s1 = SKTexture(imageNamed: "player2b")
        let s2 = SKTexture(imageNamed: "player2c")
        let s3 = SKTexture(imageNamed: "player2d")
        let s4 = SKTexture(imageNamed: "player2e")
        let s5 = SKTexture(imageNamed: "player2d")
        let s6 = SKTexture(imageNamed: "player2c")
        let s7 = SKTexture(imageNamed: "player2b")
        let s8 = SKTexture(imageNamed: "player2a")
        let textures = [s1, s2, s3, s4, s5, s6, s7, s8]
        
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player2.run(strikeAnimation)
    }
    //white win animation
    func player1WinsAnimation(){
        let t1 = SKTexture(imageNamed: "player2f")
        let t2 = SKTexture(imageNamed: "player2g")
        let t3 = SKTexture(imageNamed: "player2h")
        let t4 = SKTexture(imageNamed: "player2k")
        let t5 = SKTexture(imageNamed: "player2l")
        
        let w1 = SKTexture(imageNamed: "player1i")
        let w1a = SKTexture(imageNamed: "player1i2")
        let w2 = SKTexture(imageNamed: "player1j")
        let w3 = SKTexture(imageNamed: "player1m")
        let w4 = SKTexture(imageNamed: "player1n")
        let w5 = SKTexture(imageNamed: "player1o")
        let w6 = SKTexture(imageNamed: "player1p")
        
        //        let textures = [t1, t2, t3, t4, t5]
        //        let textures2 = [w1, w2, w3, w4, w5, w6]
        let textures = [t1, t2, t3, t3, t3, t4, t4, t4, t4, t4, t4, t5]
        let textures2 = [w1, w1, w1a, w1a, w1a, w2, w2, w2, w3, w4, w5, w6]
        
        let bleedAnimation = SKAction.animate(with: textures , timePerFrame: 0.15, resize: true, restore: false)
        let sheathAnimation = SKAction.animate(with: textures2 , timePerFrame: 0.15, resize: true, restore: false)
        
        self.player2.run(bleedAnimation)
        self.player1.run(sheathAnimation)
    }
    //black win animation
    func player2WinsAnimation(){
        
        let t1 = SKTexture(imageNamed: "player1f")
        let t2 = SKTexture(imageNamed: "player1g")
        let t3 = SKTexture(imageNamed: "player1h")
        let t4 = SKTexture(imageNamed: "player1k")
        let t5 = SKTexture(imageNamed: "player1l")
        
        let w1 = SKTexture(imageNamed: "player2i")
        let w1a = SKTexture(imageNamed: "player2i2")
        let w2 = SKTexture(imageNamed: "player2j")
        let w3 = SKTexture(imageNamed: "player2m")
        let w4 = SKTexture(imageNamed: "player2n")
        let w5 = SKTexture(imageNamed: "player2o")
        let w6 = SKTexture(imageNamed: "player2p")
        
        let textures = [t1, t2, t3, t3, t3, t4, t4, t4, t4, t4, t4, t5]
        let textures2 = [w1, w1, w1a, w1a, w1a, w2, w2, w2, w3, w4, w5, w6]
        
        
        let bleedAnimation = SKAction.animate(with: textures , timePerFrame: 0.15, resize: true, restore: false)
        let sheathAnimation = SKAction.animate(with: textures2 , timePerFrame: 0.15, resize: true, restore: false)
        
        self.player1.run(bleedAnimation)
        self.player2.run(sheathAnimation)
        
    }
    //white false start animation
    func player1FalseStart(){
        let s1 = SKTexture(imageNamed: "player1b")
        let s2 = SKTexture(imageNamed: "player1c")
        let s3 = SKTexture(imageNamed: "player1d")
        let s4 = SKTexture(imageNamed: "player1e")
        
        let textures = [s1, s2, s3, s4]
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player1.run(strikeAnimation)
        player1Miss()

    }
    //black false start animation
    func player2FalseStart(){
        let s1 = SKTexture(imageNamed: "player2b")
        let s2 = SKTexture(imageNamed: "player2c")
        let s3 = SKTexture(imageNamed: "player2d")
        let s4 = SKTexture(imageNamed: "player2e")
        
        let textures = [s1, s2, s3, s4]
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player2.run(strikeAnimation)
        player2Miss()
    }
    
    func player1Miss(){
        if hasMissed1 == true{
            let m1 = SKAction.run {
                self.missLabel1.setScale(2)
                self.missLabel1.position = CGPoint(x: 0, y: (self.size.height * -0.30))
                self.missLabel1.zPosition = 1
                self.addChild(self.missLabel1)
            }
            let m2 = SKAction.wait(forDuration: 0.1)
            let m3 = SKAction.run{
                self.missLabel1.removeFromParent()
                self.hasMissed1 = false
            }
            let seq = SKAction.sequence([m1, m2, m3])
            
            run(seq)
        }
       
    }
    
    func player2Miss(){
        if hasMissed2 == true {
            let m1 = SKAction.run {
                self.missLabel2.setScale(-2)
                self.missLabel2.position = CGPoint(x: 0, y: (self.size.height * 0.30))
                self.missLabel2.zPosition = 1
                self.addChild(self.missLabel2)
            }
            let m2 = SKAction.wait(forDuration: 0.1)
            let m3 = SKAction.run{
                self.missLabel2.removeFromParent()
                self.hasMissed2 = false
                
            }
            let seq = SKAction.sequence([m1, m2, m3])
            run(seq)
        }

    }
    
    func retry(){
        let r1 = SKAction.wait(forDuration: 1.5)
        let r2 = SKAction.run{
            self.retryButton.state = .Active
        }
        let seq = SKAction.sequence([r1, r2])
        run(seq)
        
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player1.setScale(1.5)
        player1.position = (CGPoint(x: 0, y: self.size.height * -0.10))
        player1.zPosition = 0
        self.addChild(player1)
        
        player2.setScale(1.5)
        player2.position = (CGPoint(x: 0, y: self.size.height * 0.10))
        player2.zPosition = 0
        self.addChild(player2)
        
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -4
        self.addChild(background)
        
        fightRing.setScale(2)
        fightRing.position = CGPoint(x: 0, y: 0)
        fightRing.zPosition = 1
        self.addChild(fightRing)
        
        player1StrikeBar.setScale(2)
        player1StrikeBar.position = CGPoint(x: 0, y: (self.size.height * -0.25))
        player1StrikeBar.zPosition = 1
        self.player1StrikeBar.isHidden = true
        self.addChild(player1StrikeBar)
        
        player2StrikeBar.setScale(-2)
        player2StrikeBar.position = CGPoint(x: 0, y: (self.size.height * 0.255))
        player2StrikeBar.zPosition = 1
        player2StrikeBar.isHidden = true
        self.addChild(player2StrikeBar)
        
        player1StrikeEmitter?.targetNode = self
        player1StrikeEmitter?.isHidden = true
        player1StrikeEmitter?.setScale(2.5)
        player1StrikeEmitter?.zPosition = 3
        player1StrikeTempo.setScale(2)
        player1StrikeTempo.position = CGPoint(x: 0, y: (self.size.height * -0.247))
        player1StrikeTempo.isHidden = true
        player1StrikeTempo.zPosition = 4
        player1StrikeTempo.addChild(player1StrikeEmitter!)
        self.addChild(player1StrikeTempo)
        
        player2StrikeEmitter?.targetNode = self
        player2StrikeEmitter?.isHidden = true
        player2StrikeEmitter?.setScale(2.5)
        player2StrikeEmitter?.zPosition = 3
        player2StrikeTempo.setScale(2)
        player2StrikeTempo.position = CGPoint(x: 0, y: (self.size.height * 0.252))
        player2StrikeTempo.isHidden = true
        player2StrikeTempo.zPosition = 4
        player2StrikeTempo.addChild(player2StrikeEmitter!)
        self.addChild(player2StrikeTempo)
        
        critStrikeLineA.setScale(2)
        critStrikeLineA.position = CGPoint(x: -500, y: (self.size.height * -0.249))
        critStrikeLineA.isHidden = true
        critStrikeLineA.zPosition = 3
        self.addChild(critStrikeLineA)
        
        critStrikeLineB.setScale(-2)
        critStrikeLineB.position = CGPoint(x: -500, y: (self.size.height * 0.254))
        critStrikeLineB.isHidden = true
        critStrikeLineB.zPosition = 3
        self.addChild(critStrikeLineB)
        
        strike1A.setScale(2)
        strike1A.position = CGPoint(x: -500, y: (self.size.height * -0.249))
        strike1A.isHidden = true
        strike1A.zPosition = 2
        self.addChild(strike1A)
        
        strike1B.setScale(-2)
        strike1B.position = CGPoint(x: -500, y: (self.size.height * 0.254))
        strike1B.isHidden = true
        strike1B.zPosition = 2
        self.addChild(strike1B)
        
        strike2A.setScale(2)
        strike2A.position = CGPoint(x: -500, y: (self.size.height * -0.249))
        strike2A.isHidden = true
        strike2A.zPosition = 2
        self.addChild(strike2A)

        strike2B.setScale(-2)
        strike2B.position = CGPoint(x: -500, y: (self.size.height * 0.254))
        strike2B.isHidden = true
        strike2B.zPosition = 2
        self.addChild(strike2B)

        strike3A.setScale(2)
        strike3A.position = CGPoint(x:-5000, y: (self.size.height * -0.249))
        strike3A.isHidden = true
        strike3A.zPosition = 2
        self.addChild(strike3A)

        strike3B.setScale(-2)
        strike3B.position = CGPoint(x: -500, y: (self.size.height * 0.254))
        strike3B.isHidden = true
        strike3B.zPosition = 2
        self.addChild(strike3B)

        readyButton1.setScale(2)
        readyButton1.position = CGPoint(x: 0, y: (self.size.height * -0.40))
        readyButton1.zPosition = 1
        self.addChild(readyButton1)
        
        readyButton2.setScale(2)
        readyButton2.position = CGPoint(x: 0, y: (self.size.height * 0.40))
        readyButton2.zPosition = 1
        self.addChild(readyButton2)
        
        retryButton.setScale(2)
        retryButton.position = CGPoint(x: 0, y: 0)
        retryButton.zPosition = 6
        retryButton.state = .Hidden
        self.addChild(retryButton)
        
        player1TapArea.setScale(2)
        player1TapArea.position = CGPoint(x: 0, y: self.size.height * -0.3)
        player1TapArea.zPosition = 5
        self.addChild(player1TapArea)
        
        player2TapArea.setScale(2)
        player2TapArea.position = CGPoint(x: 0, y: self.size.height * 0.3)
        player2TapArea.zPosition = 5
        self.addChild(player2TapArea)
        
        white.setScale(2)
        white.position = CGPoint(x: 0, y: 0)
        white.zPosition = -1
        white.isHidden = true
        self.addChild(white)
        
        black.setScale(2)
        black.position = CGPoint(x: 0, y: 0)
        black.zPosition = -1
        black.isHidden = true
        self.addChild(black)
        
        tapLabel1.setScale(2)
        tapLabel1.position = CGPoint(x: 0, y: (self.size.height * -0.30))
        tapLabel1.zPosition = 2
        tapLabel1.isHidden = true
        self.addChild(tapLabel1)

        tapLabel2.setScale(-2)
        tapLabel2.position = CGPoint(x: 0, y: (self.size.height * 0.30))
        tapLabel2.zPosition = 2
        tapLabel2.isHidden = true
        self.addChild(tapLabel2)
        
        tapOnFightLabel1.setScale(2)
        tapOnFightLabel1.position = CGPoint(x: 0, y: (self.size.height * -0.40))
        tapOnFightLabel1.zPosition = 2
        tapOnFightLabel1.isHidden = true
        self.addChild(tapOnFightLabel1)
        
        tapOnFightLabel2.setScale(-2)
        tapOnFightLabel2.position = CGPoint(x: 0, y: (self.size.height * 0.40))
        tapOnFightLabel2.zPosition = 2
        tapOnFightLabel2.isHidden = true
        self.addChild(tapOnFightLabel2)
        
        readyButton1.selectedHandler = {
            self.readyButton1Pressed = true
            self.readyButton1.isHidden = true
            print("Ready Player 1")
            if self.readyButton1Pressed && self.readyButton2Pressed {
                self.fightCountdown()
            }
        }
        readyButton2.selectedHandler = {
            self.readyButton2Pressed = true
            self.readyButton2.isHidden = true
            print("Ready Player 2")
            if self.readyButton1Pressed && self.readyButton2Pressed {
                self.fightCountdown()
            }
        }
        //Player1 Controls
        player1TapArea.selectedHandler = {
            if self.gameState == .GameOver {


            } else {
                if self.gameState == .AllOut {
                    self.player1TapCount += 1
                    self.player1Strike()
                }
                
                if self.gameState == .StrikeTempo{
                    self.player1Tapped = true
                    self.nowLabel1.removeFromParent()
                    switch self.roundCounter {
                        case 1: self.player1CanHit = self.isOnTop(of: self.strike1A, self.player1StrikeTempo)
                        case 2: self.player1CanHit = self.isOnTop(of: self.strike2A, self.player1StrikeTempo)
                        case 3: self.player1CanHit = self.isOnTop(of: self.strike3A, self.player1StrikeTempo)
                        default: break
                    }
                    
                    
                    if self.strikeEngaged == true && self.player1FalseStartCheck == false && self.player1CanHit {
                        print("player1hit!")
                        self.player1Strike()
                        self.player1Hit = true
                    } else {
                        self.player1FalseStartCheck = true
                        self.player1FalseStart()
                        print("player1 false start")

                    }
                    self.StrikeTempoWinner()
                }
                
                if self.gameState == .Strike || self.gameState == .Fight {
                    print("Player 1 tapped")
                    if self.fightStart == true && self.player1FalseStartCheck == false {
                        self.player1Time = self.tappedTime
                        self.player1Strike()

                        self.player1TimeLabelNode.fontName = "Roman"
                        self.player1TimeLabelNode.fontSize = 60
                        self.player1TimeLabelNode.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
                        self.player1TimeLabelNode.position = CGPoint(x: 0, y: self.size.height * -0.4)
                        self.player1TimeLabelNode.zPosition = 1
                        self.addChild(self.player1TimeLabelNode)
                        self.player1TimeLabelNode.text = "Player1: \(String(format: "%.3f", self.player1Time))"
                        self.player1TimeLabelNodeB.fontName = "Roman"
                        self.player1TimeLabelNodeB.fontSize = 60
                        self.player1TimeLabelNodeB.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
                        self.player1TimeLabelNodeB.position = CGPoint(x: 0, y: self.size.height * 0.45)
                        self.player1TimeLabelNodeB.zPosition = 1
                        self.player1TimeLabelNodeB.yScale = -1
                        self.player1TimeLabelNodeB.xScale = -1
                        self.addChild(self.player1TimeLabelNodeB)
                        self.player1TimeLabelNodeB.text = "Player1: \(String(format: "%.3f", self.player1Time))"
                        
                        print("Player 1 time:", self.player1Time)

                        self.fightLabel.removeFromParent()
                        self.player1HasTime = true
                    } else {
                        //player1 false start
                        self.player1FalseStartCheck = true
                        self.player1FalseStart()
                        //self.player1Time = 10
                        print("player1 false start")
                    }
                }
                self.round1Winner()
            }
        }
        //Player2 Controls
        player2TapArea.selectedHandler = {
            if self.gameState == .GameOver {
 

            } else {
                if self.gameState == .AllOut {
                    self.player2TapCount += 1
                    self.player2Strike()
                    
                }
                
                if self.gameState == .StrikeTempo{
                    self.player2Tapped = true
                    self.nowLabel2.removeFromParent()
                    switch self.roundCounter {
                    case 1: self.player2CanHit = self.isOnTop(of: self.strike1B, self.player2StrikeTempo)
                    case 2: self.player2CanHit = self.isOnTop(of: self.strike2B, self.player2StrikeTempo)
                    case 3: self.player2CanHit = self.isOnTop(of: self.strike3B, self.player2StrikeTempo)
                    default: break
                    }
                    
                    if self.strikeEngaged  && !self.player2FalseStartCheck && self.player2CanHit {
                        self.player2Strike()
                        self.player2Hit = true
                        print("player2hit!")

                    } else {
                        self.player2FalseStartCheck = true
                        self.player2FalseStart()
                        print("player2 false start")
                        
                    }
                    self.StrikeTempoWinner()
                }
                
                if self.gameState == .Strike || self.gameState == .Fight {
                    print("Player 2 tapped")
                    if self.fightStart == true && self.player2FalseStartCheck == false {
                        self.player2Time = self.tappedTime
                        self.player2Strike()

                        self.player2TimeLabelNode.fontName = "Roman"
                        self.player2TimeLabelNode.fontSize = 60
                        self.player2TimeLabelNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                        self.player2TimeLabelNode.position = CGPoint(x: 0, y: self.size.height * 0.4)
                        self.player2TimeLabelNode.zPosition = 1
                        self.player2TimeLabelNode.yScale = -1
                        self.player2TimeLabelNode.xScale = -1
                        self.addChild(self.player2TimeLabelNode)
                        self.player2TimeLabelNode.text = "Player2: \(String(format: "%.3f", self.player2Time))"
                        
                        self.player2TimeLabelNodeB.fontName = "Roman"
                        self.player2TimeLabelNodeB.fontSize = 60
                        self.player2TimeLabelNodeB.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                        self.player2TimeLabelNodeB.position = CGPoint(x: 0, y: self.size.height * -0.45)
                        self.player2TimeLabelNodeB.zPosition = 1
                        self.addChild(self.player2TimeLabelNodeB)
                        self.player2TimeLabelNodeB.text = "Player2: \(String(format: "%.3f", self.player2Time))"
                        
                        print("Player 2 time:", self.player2Time)

                        self.fightLabel.removeFromParent()
                        self.player2HasTime = true
                    } else {
                        //player2 false start
                        self.player2FalseStartCheck = true
                        self.player2FalseStart()
                        //self.player2Time = 10
                        print("player2 false start")
                    }
                }
                self.round1Winner()
            }
        }
        retryButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFit//.AspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
            
            self.allOutModeEnabled = false
        }
    }
    //start time from view load minus time at tap
    func calcTime(timer: Timer){
        time = Date().timeIntervalSinceReferenceDate - startTime
        //timeLabel = String(format: "%.3f", time)
        //print(String(format: "%.3f", time))
        
        tappedTime = time
    }
    //generates random time from range
    func randomTime(range: Int) -> CGFloat {
        let rInt = Int(arc4random() % UInt32(range * 1000))
        return CGFloat(rInt) / 1000
    }
    
    func randomStrikeTime(range: Int) -> CGFloat {
        let randX = Int(arc4random_uniform(720) + 1)
        return CGFloat(randX) - 360
    }
    
        //after ready buttons are pressed, gameState Strike, fight countdown begins with random interval times
    func fightCountdown() {
        self.tapOnFightLabel1.isHidden = false
        self.tapOnFightLabel2.isHidden = false
        print("Both Players Ready")
        
        let waitTime1 = randomTime(range: 1) + 1
        let waitTime2 = randomTime(range: 2) + 1
        let waitTime3 = randomTime(range: 6)
        
        let wait1 = SKAction.wait(forDuration: TimeInterval(waitTime1))
        let wait2 = SKAction.wait(forDuration: TimeInterval(waitTime2))
        let wait3 = SKAction.wait(forDuration: TimeInterval(waitTime3))
        
        let prep = SKAction.run {
            print("Prepare")
            self.prepareLabel.setScale(2)
            self.prepareLabel.position = CGPoint(x: 0, y: 0)
            self.addChild(self.prepareLabel)
            self.gameState = .Strike
            self.player1TapArea.state = .Active
            self.player2TapArea.state = .Active
            SKAction.playSoundFileNamed("Yoooo", waitForCompletion: false)
           
        }
        
        let to = SKAction.run {
            print("to")
            self.prepareLabel.removeFromParent()
            self.toLabel.setScale(2)
            self.tapOnFightLabel1.isHidden = true
            self.tapOnFightLabel2.isHidden = true
            self.addChild(self.toLabel)
        }
        
        let fight = SKAction.run {
            print("Fight")
            self.toLabel.removeFromParent()
            self.fightLabel.setScale(2.5)
            self.addChild(self.fightLabel)
            self.gameState = .Fight
            self.fightStart = true
            SKAction.playSoundFileNamed("bottle", waitForCompletion: false)

            print("Timers Enabled")
        }
        let countdown = SKAction.sequence([wait1, prep, wait2, to, wait3, fight])
        run(countdown)
        print("Countdown Start")
    }
    //winner check for reflex fight
    func round1Winner(){
        if self.player1FalseStartCheck == true && self.player2FalseStartCheck == false && self.gameState == .Fight {
            Player2Wins()
        } else if self.player1FalseStartCheck == false && self.player2FalseStartCheck == true && self.gameState == .Fight {
            Player1Wins()
        } else if self.player1FalseStartCheck == true && self.player2FalseStartCheck == true {
            self.gameState = .GameOver
            self.fightLabel.removeFromParent()
            retry()
        } else if self.player1FalseStartCheck == false && self.player2FalseStartCheck == false && self.gameState == .Fight {
            if self.player1Time < self.player2Time && self.player1Time != 0 {
                if self.player2Time - self.player1Time > 0.2{
                    //player1WinsLabel and animations
                    Player1Wins()
                } else {
                    gameState = .BeginTempo
                }
                
            } else if self.player2Time < self.player1Time && self.player2Time != 0 {
                if self.player1Time - self.player2Time > 0.2 {
                    //player2WinsLabel and animations
                    Player2Wins()
                } else {
                    gameState = .BeginTempo
                    
                }
                
            } else if self.player1Time == self.player2Time {
                
                black.isHidden = false
                white.isHidden = false
                gameState = .AllOut
                
                AllOutMode()
            }
        }
    }
    
    func beginTempo() {
        // One time stuff before starting tempo game
        print("**** Begin Tempo mode....")
        self.player1StrikeBar.isHidden = false
        self.player2StrikeBar.isHidden = false
        self.player1StrikeTempo.isHidden = false
        self.player2StrikeTempo.isHidden = false
        self.player1StrikeEmitter?.isHidden = false
        self.player2StrikeEmitter?.isHidden = false
        
        waitLabel1.setScale(-2)
        waitLabel1.position = CGPoint(x: 0, y: (self.size.height * 0.30))
        waitLabel1.zPosition = 1
        waitLabel2.setScale(2)
        waitLabel2.position = CGPoint(x: 0, y: (self.size.height * -0.30))
        waitLabel2.zPosition = 1
        self.addChild(waitLabel1)
        self.addChild(waitLabel2)
        
        // start tempo actions ...
        let moveLeft = SKAction.moveTo(x: -340, duration: 0.5)
        let moveRight = SKAction.moveTo(x: 340, duration: 0.5)
        
        // first box starts here
        // action wait random time, run block show strikeBox and
        self.player1StrikeTempo.run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
        self.player2StrikeTempo.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
        
        // FIXME: Start strike tempo timer ...
        gameState = .StrikeTempo
        roundCounter = 0
        tempoActionForge()
    }
    
    let TEMPO_ACTION_KEY = "TEMPO_ACTION_KEY"
    
    func tempoActionForge() {
        print("strike tempo timer")
        let wait = SKAction.wait(forDuration: Double(self.randomTime(range: 2) + 1))
        let done = SKAction.run {
            self.StrikeTempoMode()
        }
        let seq = SKAction.sequence([wait, done])
        run(seq, withKey: TEMPO_ACTION_KEY)
        
        // Somewhere else ... 
        // When someone scores on tempo
        // removeAction(forKey: TEMPO_ACTION_KEY)
    }
    
    func StrikeTempoMode() {

        // FIXME: Called from timer countdown ...
        
        print("strike tempo enabled")
        let maxRounds = 3
        roundCounter += 1
        print("Round counter: ", roundCounter)
        if roundCounter <= maxRounds {
            if self.roundCounter == 1 {
                print("round1")
                self.strike1A.position.x = player1StrikeTempo.position.x
                
                self.strike1A.isHidden = false
                
                self.strike1B.position.x = player2StrikeTempo.position.x
                self.strike1B.isHidden = false
                
                self.strikeEngaged = true
                
                waitLabel1.removeFromParent()
                waitLabel2.removeFromParent()
                nowLabel1.setScale(-2)
                nowLabel1.position = CGPoint(x: 0, y: (self.size.height * 0.30))
                nowLabel1.zPosition = 1
                nowLabel2.setScale(2)
                nowLabel2.position = CGPoint(x: 0, y: (self.size.height * -0.30))
                nowLabel2.zPosition = 1
                self.addChild(nowLabel1)
                self.addChild(nowLabel2)
            } else if self.roundCounter == 2 {
                self.strike2A.position.x = player1StrikeTempo.position.x
                self.strike2A.isHidden = false
                
                self.strike2B.position.x = player2StrikeTempo.position.x
                self.strike2B.isHidden = false
                
                self.strikeEngaged = true
            } else if self.roundCounter == 3 {
                self.strike3A.position.x = player1StrikeTempo.position.x
                self.strike3A.isHidden = false
                
                self.strike3B.position.x = player2StrikeTempo.position.x
                self.strike3B.isHidden = false
                
                self.strikeEngaged = true
            }
            
        } else {
            gameState = .AllOut
            self.player1StrikeBar.isHidden = true
            self.player2StrikeBar.isHidden = true
            self.player1StrikeTempo.isHidden = true
            self.player2StrikeTempo.isHidden = true
            self.player1StrikeEmitter?.isHidden = true
            self.player2StrikeEmitter?.isHidden = true
            
            AllOutMode()
        }
        
//        if roundCounter == 0 && gameState == .StrikeTempo {
//            print("tempo timer begins")
//            self.randomTempoTimer = Double(self.randomTime(range: 6) + 1)
//            roundCounter += 1
//            // check roundCounter > 3
//        }

    }
    
    func StrikeTempoWinner() {
        
        print("-- called strike tempo winner")
        print("*****************************")
        
        if player1Tapped ==  true && player2Tapped == true {
            print("-- both players tapped")
            if player1FalseStartCheck == true && player2FalseStartCheck == true {
                print("-- both miss")
                player1Strike()
                player2Strike()
                player1Tapped = false
                player2Tapped = false
                player1FalseStartCheck = false
                player2FalseStartCheck = false
                
            } else {
                print("-- one player wins")
                if player2FalseStartCheck == true && player1FalseStartCheck == false && player1Hit == true {
                    print("---- player 1 wins")
                    Player1Wins()
                    
                }
                else if player1FalseStartCheck == true && player2FalseStartCheck == false && player2Hit == true {
                    print("---- player 2 wins")
                    Player2Wins()
                    
                }
                
                if roundCounter == 1 && player1Hit == true && player2Hit == true {
                    strike1A.removeFromParent()
                    strike1B.removeFromParent()
                    player1Tapped = false
                    player2Tapped = false
                    strikeEngaged = false
                    player1Hit = false
                    player2Hit = false
                    tempoActionForge()
                }
                if roundCounter == 2 && player1Hit == true && player2Hit == true {
                    strike2A.removeFromParent()
                    strike2B.removeFromParent()
                    player1Tapped = false
                    player2Tapped = false
                    strikeEngaged = false
                    player1Hit = false
                    player2Hit = false
                    tempoActionForge()
                }
                if roundCounter == 3 && player1Hit == true && player2Hit == true {
                    strike3A.removeFromParent()
                    strike3B.removeFromParent()
                    player1Tapped = false
                    player2Tapped = false
                    strikeEngaged = false
                    player1Hit = false
                    player2Hit = false
                    StrikeTempoMode()
                }

            }
        }
    }
    
    
    func AllOutMode() {
        allOutModeEnabled = true
        if gameState == .AllOut {
            print("Tap Attack!")
        }
        tapLabel1.isHidden = false
        tapLabel2.isHidden = false
        TapAttackPulse()

        //initiate 5 second countdown TAP!
        print(gameState)
        print(allOutCountDown)
  
    }
    
    func allOutModeWinner(){
        if player1TapCount > player2TapCount && allOutCountDown <= 0 {
            self.Player1Wins()
            print(player1TapCount)
            print(player2TapCount)
            self.tapLabel1.removeFromParent()
            self.tapLabel2.removeFromParent()
            
        } else if player1TapCount < player2TapCount && allOutCountDown <= 0 {
            self.Player2Wins()
            print(player1TapCount)
            print(player2TapCount)
            self.tapLabel1.removeFromParent()
            self.tapLabel2.removeFromParent()
        } else if player1TapCount == player2TapCount && allOutCountDown <= 0 {
            print("Draw")
            self.gameState = .GameOver
            self.tapLabel1.removeFromParent()
            self.tapLabel2.removeFromParent()
            retry()
            print(player1TapCount)
            print(player2TapCount)
            if allOutModeEnabled == true {
                Player1TapCount()
                Player2TapCount()
            }
            drawLabel1.setScale(-2)
            drawLabel1.position = CGPoint(x: 0, y: (self.size.height * 0.30))
            drawLabel1.zPosition = 1
            drawLabel2.setScale(2)
            drawLabel2.position = CGPoint(x: 0, y: (self.size.height * -0.30))
            drawLabel2.zPosition = 1
            self.addChild(drawLabel1)
            self.addChild(drawLabel2)
            
        }
    }
    
    func Player1Wins() {
        print("Player 1 Wins!")
        youWinLabel.setScale(2)
        youWinLabel.position = CGPoint(x: 0, y: (self.size.height * -0.30))
        youWinLabel.zPosition = 1
        youLoseLabel.setScale(2)
        youLoseLabel.position = CGPoint(x: 0, y: (self.size.height * 0.30))
        youLoseLabel.zPosition = 1
        player1WinsAnimation()
        
        self.addChild(youWinLabel)
        self.addChild(youLoseLabel)
        gameState = .GameOver
        retry()
        gameOver = true
        if allOutModeEnabled == true {
            Player1TapCount()
            Player2TapCount()
        }
    }
    
    func Player2Wins() {
        print("Player 2 Wins!")
        youWinLabel.setScale(-2)
        youWinLabel.position = CGPoint(x: 0, y: (self.size.height * 0.30))
        youWinLabel.zPosition = 1
        youLoseLabel.setScale(-2)
        youLoseLabel.position = CGPoint(x: 0, y: (self.size.height * -0.30))
        youLoseLabel.zPosition = 1
        player2WinsAnimation()
        
        self.addChild(youWinLabel)
        self.addChild(youLoseLabel)
        gameState = .GameOver
        retry()
        gameOver = true
        if allOutModeEnabled == true {
            Player1TapCount()
            Player2TapCount()
        }

    }
    //display player 2 tap count for all out mode
    func Player2TapCount() {
        self.player2TapLabelNode.fontName = "Roman"
        self.player2TapLabelNode.fontSize = 60
        self.player2TapLabelNode.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.player2TapLabelNode.position = CGPoint(x: 0, y: self.size.height * 0.5)
        self.player2TapLabelNode.zPosition = 1
        self.player2TapLabelNode.yScale = -1
        self.player2TapLabelNode.xScale = -1
        self.addChild(self.player2TapLabelNode)
        self.player2TapLabelNode.text = "Taps: \(String(self.player2TapCount))"
    }
    //display player 1 tap count for all out mode
    func Player1TapCount() {
        self.player1TapLabelNode.fontName = "Roman"
        self.player1TapLabelNode.fontSize = 60
        self.player1TapLabelNode.fontColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        self.player1TapLabelNode.position = CGPoint(x: 0, y: self.size.height * -0.5)
        self.player1TapLabelNode.zPosition = 1
        self.player1TapLabelNode.yScale = 1
        self.player1TapLabelNode.xScale = 1
        self.addChild(self.player1TapLabelNode)
        self.player1TapLabelNode.text = "Taps: \(String(self.player1TapCount))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    
    // MARK: - Update
    // FIXME: Problem entering Tempo state...
    
    override func update(_ currentTime: TimeInterval) {
        
        switch gameState {
        case .AllOut:
            break
            
        case .Fight:
            if !timeFlag {
                startTime = Date().timeIntervalSinceReferenceDate
                timer = Timer.scheduledTimer(timeInterval: 0.001,
                                             target: self,
                                             selector: #selector(calcTime(timer:)),
                                             userInfo: nil,
                                             repeats: true)
                timeFlag = true
            }
            break
            
        case .GameOver:
            break
            
        case .Ready:
            break
            
        case .Strike:
            break
            
        case .BeginTempo:
            beginTempo()
            break
            
        case .StrikeTempo:
            // tempo()
//            if isOnTop(of: self.strike1A, self.player1StrikeTempo) {
//                self.player1CanHit = true
//            } else {
//                self.player1CanHit = false
//            }
//            if isOnTop(of: self.strike1B, self.player2StrikeTempo) {
//                self.player2CanHit = true
//            } else {
//                self.player2CanHit = false
//            }
//            if isOnTop(of: self.strike2A, self.player1StrikeTempo) {
//                self.player1CanHit = true
//            } else {
//                self.player1CanHit = false
//            }
//            if isOnTop(of: self.strike2B, self.player2StrikeTempo) {
//                self.player2CanHit = true
//            } else {
//                self.player2CanHit = false
//            }
//            if isOnTop(of: self.strike3A, self.player1StrikeTempo) {
//                self.player1CanHit = true
//            } else {
//                self.player1CanHit = false
//            }
//            if isOnTop(of: self.strike3B, self.player2StrikeTempo) {
//                self.player2CanHit = true
//            } else {
//                self.player2CanHit = false
//            }
            break
            
        }
        
        
        
        if gameState == .Fight {
    
        }
        if gameState == .StrikeTempo {
            
        }
        if gameState == .AllOut && allOutCountDown > 0 {
            allOutCountDown -= fixedDelta
            if allOutCountDown <= 0{
                
                allOutModeWinner()
            }
        }
        if gameState == .GameOver {
            retryCountDown -= fixedDelta
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        if player1StrikeTempo.intersects(strike1A){
//            player1CanHit = true

//        }
//        if player2StrikeTempo.intersects(strike1B){
//            print("player2CanHit")
//            player2CanHit = true
//        }
//        if player1StrikeTempo.intersects(strike2A){
//            player1CanHit = true
//        }
//        if player2StrikeTempo.intersects(strike2B){
//            player2CanHit = true
//        }
//        if player1StrikeTempo.intersects(strike3A){
//            player1CanHit = true
//        }
//        if player2StrikeTempo.intersects(strike3B){
//            player2CanHit = true
//        }
//        if player1StrikeTempo.intersects(critStrikeLineA){
//            player1CanCrit = true
//        }
//        if player2StrikeTempo.intersects(critStrikeLineB){
//            player2CanCrit = true
//        }
        
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    func isOnTop(of strike: SKSpriteNode, _ tempo: SKSpriteNode) -> Bool {
        let halfWidth = strike.size.width / 2
        let startX = strike.position.x - halfWidth
        let endX = strike.position.x + halfWidth
        
        if startX < tempo.position.x && endX > tempo.position.x {
            return true
        }
        
        return false
    }
}
