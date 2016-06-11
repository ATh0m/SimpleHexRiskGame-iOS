//
//  Human.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 6/11/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/// Klasa do zarządzania akcjami 'ludzkiego' gracza
class Human: Player {
    
    /**
     Akcja do wykonania w trakcie stanu Start
     */
    override func actionStartIn(nodes: [SKNode]) -> Bool {
        
        for node in nodes {
            if let tileShape = node as? Tile.TileShape {
                let tile = tileShape.tile
                
                if tile.owner != nil { return false }
                
                tile.owner = self
                tile.force = 3
                tiles.append(tile)
                
                return true
            }
        }
        
        return false
    }
    
    /**
     Akcja do wykonania przed stanem Reinforcement
     */
    override func actionReinforcementPre() -> Bool {
        
        self.reinforcements = UInt(max(2, self.tiles.count / 3))
        
        for tile in self.tiles {
            tile.shape.strokeColor = self.actionColor
            tile.actionable = true
        }
        
        return true
    }
    
    /**
     Akcja do wykonania w trakcie stanu Reinforcement
     */
    override func actionReinforcementIn(nodes: [SKNode]) -> Bool {
        
        for node in nodes {
            if let tileShape = node as? Tile.TileShape {
                let tile = tileShape.tile
                
                if tile.owner === self {
                    tile.force += 1
                    self.reinforcements -= 1
                }
                
                return reinforcements <= 0
            }
        }
        
        return false
        
    }
    
    /**
     Akcja do wykonania przed stanem Move
     */
    override func actionMovePre() -> Bool {
        
        for tile in tiles {
            tile.shape.strokeColor = actionColor
            tile.actionable = true
            for neighbourTile in tile.neighbours {
                neighbourTile.shape.strokeColor = actionColor
                neighbourTile.actionable = true
            }
        }
        
        return true
    }
    
    /**
     Akcja do wykonania w trakcie stanu Move
     */
    override func actionMoveIn(nodes: [SKNode]) -> Bool {
        
        for node in nodes {
            if let tileShape = node as? Tile.TileShape {
                let tile = tileShape.tile
                
                if tile.actionable {
                    
                    if tile.owner === self {
                        
                        tile.force += 2
                        
                    } else if tile.owner == nil {
                        
                        var attackPower: UInt = 0
                        
                        for neighbourTile in tile.neighbours {
                            if neighbourTile.owner === self {
                                attackPower += neighbourTile.force / 2
                            }
                        }
                        
                        if attackPower <= 0 { return false }
                        
                        tile.owner = self
                        tile.force = attackPower
                        
                        tiles.append(tile)
                        
                    } else if tile.owner !== self {
                        
                        var attackPower: UInt = 0
                        
                        for neighbourTile in tile.neighbours {
                            if neighbourTile.owner === self {
                                attackPower += neighbourTile.force / 2
                                neighbourTile.force -= neighbourTile.force / 2
                            }
                        }
                        
                        let defensePower = tile.force
                        
                        let (leftAttackPower, leftDefensePower) = Battle.battle(attackPower, defense: defensePower)
                        
                        if leftAttackPower > 0 {
                            
                            let opponent: Player! = tile.owner
                            
                            let index = opponent.tiles.indexOf({$0 === tile})
                            opponent.tiles.removeAtIndex(index!)
                            
                            tiles.append(tile)
                            tile.owner = self
                            tile.force = leftAttackPower
                            
                            if opponent.tiles.count == 0 {
                                opponent.active = false
                            }
                            
                        } else {
                            tile.force = leftDefensePower
                        }
                        
                    } else { return false }
                    
                    return true
                }
                
                return false
            }
        }
        
        return false
    }
}