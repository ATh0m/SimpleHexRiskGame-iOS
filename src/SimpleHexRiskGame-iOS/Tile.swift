//
//  Tile.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/29/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

class Tile {
    
    var position: CGPoint = CGPointZero
    var actionable: Bool = false
    
    var owner: Player? = nil {
        didSet {
            shape.fillColor = owner!.tileColor
        }
    }
    var force: UInt = 0 {
        didSet {
            shape.label.text = String(force)
        }
    }
    
    var neighbours: [Tile] = [Tile]()
    
    var shape: TileShape! = nil
    
    class TileShape: SKShapeNode {
        var tile: Tile! = nil
        var label: SKLabelNode! = nil
        var center: CGPoint = CGPointZero
        
        convenience init(tile: Tile, size: CGFloat, translation: CGVector) {
            
            let center: CGPoint = CGPoint(x: tile.position.x * (size + 1), y: tile.position.y * (size + 1)) + translation
            
            self.init()
            self.init(points: TileShape.vertices(center, size: size), count: 7)
            
            self.tile = tile
            self.center = center
            
            self.fillColor = SKColor.grayColor()
            self.strokeColor = SKColor.clearColor()
            self.lineWidth = 3
            
            label = SKLabelNode(fontNamed: "Arial")
            label.text = String(tile.force)
            label.fontSize = 20
            label.position = center
            
            label.verticalAlignmentMode = .Center
            label.horizontalAlignmentMode = .Center
            
            self.addChild(label)
            
        }
        
        static func vertices(center: CGPoint, size: CGFloat) -> UnsafeMutablePointer<CGPoint> {
            
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
    
    init(position: CGPoint) {
        self.position = position
    }
    
    func createShape(size: CGFloat, translation: CGVector) {
        shape = TileShape.init(tile: self, size: size, translation: translation)
    }
    
}