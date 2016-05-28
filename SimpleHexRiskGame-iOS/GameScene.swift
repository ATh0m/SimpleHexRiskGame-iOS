//
//  GameScene.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright (c) 2016 Tomasz Nanowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
         */
        
        /*
        let myObject = SKShapeNode(points: points, count: 7)
        myObject.fillColor = SKColor.redColor()
        myObject.strokeColor = SKColor.blueColor()
        myObject.lineWidth = CGFloat(5)
        
        self.addChild(myObject)
        */
        
        _ = MapGenerator.generateMap(CGSizeMake(10, 10), rate: 0.5)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            // FIXME - naprawić naciskanie na ilość punktów
            if let hex = node as? Hex {
                hex.force += 1
            }
        
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
