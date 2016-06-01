//
//  GameScene.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright (c) 2016 Tomasz Nanowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game: Gameplay!
    
    var message: SKLabelNode! = nil
    var messageDescription: SKLabelNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        game = Gameplay(gameScene: self)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
