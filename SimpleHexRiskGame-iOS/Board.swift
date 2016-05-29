//
//  Board.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

class Board {
    
    var tiles: [Tile] = [Tile]()
    var tilesAmount: UInt = 0
    
    init(minTilesAmount: UInt, maxTilesAmount: UInt) {
        
        let tilesAmount = minTilesAmount + UInt(arc4random()) % (maxTilesAmount - minTilesAmount)
        generate(tilesAmount, tileDirections: [CGVector(dx: 2, dy: 0), CGVector(dx: 1, dy: 1.5), CGVector(dx: 1, dy: -1.5), CGVector(dx: -2, dy: 0), CGVector(dx: -1, dy: -1.5), CGVector(dx: -1, dy: 1.5)], probability: 0.8)
        
    }
    
    func generate(tilesAmount: UInt, tileDirections: [CGVector], probability: CGFloat) {
        
        srand(UInt32(time(nil)))
        srand48(time(nil))
        
        var tilesAmount_ = tilesAmount
        
        self.tilesAmount = tilesAmount
        self.tiles.removeAll()
        
        tiles.append(Tile(position: CGPointMake(0, 0)))
        tilesAmount_ -= 1
        
        var index = 0
        var position, newPosition: CGPoint
        
        while tilesAmount_ > 0 {
            
            position = tiles[index].position
            
            for direction in tileDirections {
                
                newPosition = position + direction
                
                if CGFloat(drand48()) > probability {
                    
                    if tiles.indexOf({ $0.position == newPosition }) == nil {
                        let newTile = Tile(position: newPosition)
                        
                        tiles.append(newTile)
                        
                        for tile in tiles {
                            for direction_ in tileDirections {
                                if (tile.position + direction_) == newTile.position {
                                    tile.neighbours.append(newTile)
                                    newTile.neighbours.append(tile)
                                }
                            }
                        }
                        
                        tilesAmount_ -= 1
                        if tilesAmount_ <= 0 {
                            break
                        }
                    }
                    
                }
                
            }
            
            index = (index + 1) % tiles.count
            
        }
        
    }
    
}












