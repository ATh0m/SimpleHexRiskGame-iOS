//
//  Tile.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/29/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/// Klasa zawierająca informacje o konkretnym polu
class Tile {
    
    /// Pozycja na planszy
    var position: CGPoint = CGPointZero
    /// Informacja o tym czy na polu można wykonać akcję
    var actionable: Bool = false
    
    /// Właściciel pola
    var owner: Player? = nil {
        didSet {
            shape.fillColor = owner!.tileColor
        }
    }
    /// Ilość jednostek znajdujących się na polu
    var force: UInt = 0 {
        didSet {
            shape.label.text = String(force)
        }
    }
    
    /// Lista sąsiadujących pól
    var neighbours: [Tile] = [Tile]()
    
    /// Graficzny wygląd pola
    var shape: TileShape! = nil
    
    /// Klasa odpowiedzialna za wyświetlanie pola
    class TileShape: SKShapeNode {
        /// Wskażnik na pwłaściwe ole
        var tile: Tile! = nil
        /// Etykieta do wyświetlania siły pola
        var label: SKLabelNode! = nil
        /// Środek graficznej reprezentacji pola
        var center: CGPoint = CGPointZero
        
        /**
         Tworzenie graficznej reprezentacji pola
         
         - parameter tile:        Pole do wyświetlenia
         - parameter size:        Rozmiar pola do wyświetlenia
         - parameter translation: Przesunięcie o wektor
         */
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
        
        /**
         Lista wierzchołków danego pola
         
         - parameter center: Środek pola
         - parameter size:   Rozmiar pola
         
         - returns: Lista wierzchołków graficznego pola
         */
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
    
    /**
     Tworzenie nowego pola
     
     - parameter position: Pozycja
     */
    init(position: CGPoint) {
        self.position = position
    }
    
    /**
     Tworzenie graficznej reprezentacji danego pola
     
     - parameter size:        Rozmiar pola
     - parameter translation: Przesunięcie o wektor
     */
    func createShape(size: CGFloat, translation: CGVector) {
        shape = TileShape.init(tile: self, size: size, translation: translation)
    }
    
}