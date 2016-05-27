//
//  Hexagon.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

class Hex {
    var force: UInt = 0
    // var owner: Player?
    
    var position: CGPoint
    var size: CGFloat = 0
    
    var shape: SKShapeNode
    
    init(position: CGPoint, size: CGFloat) {
        self.position = position
        self.size = size
        
        self.force = 0
        // self.owner = nil
        
        let x = position.x
        let y = position.y
        
        let points = UnsafeMutablePointer<CGPoint>.alloc(7)
        points[0] = CGPoint(x: x - size, y: y + size / 2.0)
        points[1] = CGPoint(x: x - size, y: y - size / 2.0)
        points[2] = CGPoint(x: x, y: y - size)
        points[3] = CGPoint(x: x + size, y: y - size / 2.0)
        points[4] = CGPoint(x: x + size, y: y + size / 2.0)
        points[5] = CGPoint(x: x, y: y + size)
        points[6] = CGPoint(x: x - size, y: y + size / 2.0)
        
        self.shape = SKShapeNode(points: points, count: 7)
    }
    
    func display() {
        
    }
    
    func displayFilled() {
        
    }
    
}