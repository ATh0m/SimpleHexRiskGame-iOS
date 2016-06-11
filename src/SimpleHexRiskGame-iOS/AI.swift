//
//  AI.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 6/11/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/// Klasa do zarządzania akcjami SI
class AI: Player {
    
    /**
     Akcja do wykonania przed stanem Start
     */
    override func actionStartPre() -> Bool {
        srandom(UInt32(time(nil)))
        
        var tile = game.board.tiles[random() % game.board.tiles.count]
        
        while tile.owner != nil {
            tile = game.board.tiles[random() % game.board.tiles.count]
        }
        
        tile.owner = self
        tile.force = 3
        tiles.append(tile)
        
        return true
    }
    
    /**
     Akcja do wykonania przed stanem Reinforcement
     */
    override func actionReinforcementPre() -> Bool {
        reinforcements = UInt(max(3, tiles.count / 2))
        
        prepareInfoAboutTiles()
        
        srand48(time(nil))
        srandom(UInt32(time(nil)))
        
        var tile: Tile
        
        while reinforcements > 0 {
            if tilesAdjacentEnemies.count > 0 && (drand48() < 0.75 || tilesAdjacentNeutral.count == 0) {
                tile = tilesAdjacentEnemies[random() % tilesAdjacentEnemies.count]
            } else if tilesAdjacentNeutral.count > 0 {
                tile = tilesAdjacentNeutral[random() % tilesAdjacentNeutral.count]
            } else {
                tile = tiles[random() % tiles.count]
            }
            
            tile.force += 1
            reinforcements -= 1
        }
        
        return true
        
    }
    
    /**
     Akcja do wykonania przed stanem Move
     */
    override func actionMovePre() -> Bool {
        
        srand48(time(nil))
        srandom(UInt32(time(nil)))
        
        var tile: Tile
        
        if drand48() < 0.75 || actionableEnemyTiles.isEmpty {
            
            if !actionableEnemyTiles.isEmpty && (drand48() < 0.35 || actionableNeutralTiles.isEmpty) {
                
                actionableEnemyTiles = actionableEnemyTiles.sort({$0.force > $1.force})
                
                if drand48() < 0.5 {
                    tile = actionableEnemyTiles.first!
                } else {
                    tile = actionableEnemyTiles[random() % actionableEnemyTiles.count]
                }
                
            } else if !actionableNeutralTiles.isEmpty {
                tile = actionableNeutralTiles[random() % actionableNeutralTiles.count]
                
            } else {
                tile = tiles[random() % tiles.count]
                
            }
            
        } else {
            if !tilesAdjacentEnemies.isEmpty {
                tile = tilesAdjacentEnemies[random() % tilesAdjacentEnemies.count]
                
            } else if !tilesAdjacentNeutral.isEmpty {
                tile = tilesAdjacentNeutral[random() % tilesAdjacentNeutral.count]
                
            } else {
                tile = tiles[random() % tiles.count]
            }
            
        }
        
        if tile.owner === self {
            
            tile.force += 3
            
        } else if tile.owner == nil {
            
            var attackPower:UInt = 0
            
            for neighbourTile in tile.neighbours {
                if neighbourTile.owner === self {
                    attackPower += UInt(CGFloat(neighbourTile.force) / 2.5)
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
    
}
