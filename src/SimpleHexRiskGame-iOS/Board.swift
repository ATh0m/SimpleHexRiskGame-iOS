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
    
    var size: CGSize = CGSizeZero
    
    init(minTilesAmount: UInt, maxTilesAmount: UInt) {
        
        let tilesAmount = minTilesAmount + UInt(arc4random()) % (maxTilesAmount - minTilesAmount)
        let result = generate(tilesAmount, tileDirections: [CGVector(dx: 2, dy: 0), CGVector(dx: 1, dy: 1.5), CGVector(dx: 1, dy: -1.5), CGVector(dx: -2, dy: 0), CGVector(dx: -1, dy: -1.5), CGVector(dx: -1, dy: 1.5)], probability: 0.8, maxSize: CGSize(width: 18, height: 10))
        
        size = CGSize(width: result.maxPoint.x - result.minPoint.x, height: result.maxPoint.y - result.minPoint.y)
        
        let translation: CGVector = CGVector(dx: 0 - result.minPoint.x, dy: 0 - result.minPoint.y)
        
        for tile in tiles {
            tile.position += translation
        }
    }
    
    func generate(tilesAmount: UInt, tileDirections: [CGVector], probability: CGFloat, maxSize: CGSize) -> (minPoint: CGPoint, maxPoint: CGPoint) {
        
        srand(UInt32(time(nil)))
        srand48(time(nil))
        
        var tilesAmount_ = tilesAmount
        
        self.tilesAmount = tilesAmount
        self.tiles.removeAll()
        
        tiles.append(Tile(position: CGPointMake(0, 0)))
        tilesAmount_ -= 1
        
        var index = 0
        var position, newPosition: CGPoint
        
        var minPoint: CGPoint = CGPointZero
        var maxPoint: CGPoint = CGPointZero
        
        while tilesAmount_ > 0 {
            
            position = tiles[index].position
            
            for direction in tileDirections {
                
                newPosition = position + direction
                
                let newMinPoint = CGPoint(x: min(minPoint.x, newPosition.x), y: min(minPoint.y, newPosition.y))
                let newMaxPoint = CGPoint(x: max(maxPoint.x, newPosition.x), y: max(maxPoint.y, newPosition.y))
                
                if newMaxPoint.x - newMinPoint.x > maxSize.width || newMaxPoint.y - newMinPoint.y > maxSize.height {
                    continue
                }
                
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
                        
                        minPoint = newMinPoint
                        maxPoint = newMaxPoint
                        
                        tilesAmount_ -= 1
                        if tilesAmount_ <= 0 {
                            break
                        }
                    }
                    
                }
                
            }
            
            index = (index + 1) % tiles.count
            
        }
        
        
        return (minPoint, maxPoint)
    }
    
}












