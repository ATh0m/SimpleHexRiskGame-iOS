//
//  Player.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/29/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    var name: String = ""
    
    var active: Bool = false
    
    var tileColor: SKColor
    var actionColor: SKColor
    
    var reinforcements: UInt = 0
    
    var tiles: [Tile] = [Tile]()
    
    init(name: String, tileColor: SKColor, actionColor: SKColor) {
        self.name = name
        self.tileColor = tileColor
        self.actionColor = actionColor
        
        self.active = true
    }
}

class Human: Player {
    
}

class AI: Player {
    
}