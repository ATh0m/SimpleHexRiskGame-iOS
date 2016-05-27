//
//  Hexagon.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

class Hex: SKShapeNode {
    
    var force: UInt = 0 {
        didSet {
            label.text = String(force)
        }
    }
    var label: SKLabelNode! = nil
    // var owner: Player?
    
    convenience init(position: CGPoint, size: CGFloat) {
        
        let vertices = Hex.verticesList(position, size: size)
        
        self.init()
        self.init(points: vertices, count: 7)
        
        self.force = 0
        // self.owner = nil
        
        label = SKLabelNode(fontNamed: "Arial")
        label.text = String(self.force)
        label.fontSize = 20
        label.position = position
        
        label.verticalAlignmentMode = .Center
        label.horizontalAlignmentMode = .Center
        
        self.addChild(label)
        
    }
    
    static func verticesList(center: CGPoint, size: CGFloat) -> UnsafeMutablePointer<CGPoint> {
        
        let x = center.x
        let y = center.y
        
        let vertices = UnsafeMutablePointer<CGPoint>.alloc(7)
        vertices[0] = CGPoint(x: x - size, y: y + size / 2.0)
        vertices[1] = CGPoint(x: x - size, y: y - size / 2.0)
        vertices[2] = CGPoint(x: x, y: y - size)
        vertices[3] = CGPoint(x: x + size, y: y - size / 2.0)
        vertices[4] = CGPoint(x: x + size, y: y + size / 2.0)
        vertices[5] = CGPoint(x: x, y: y + size)
        vertices[6] = CGPoint(x: x - size, y: y + size / 2.0)
        
        return vertices
    }
    
}