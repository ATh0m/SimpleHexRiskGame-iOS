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
    
    var game: Gameplay
    
    var tiles: [Tile] = [Tile]()
    
    var actionableNeutralTiles: [Tile] = [Tile]()
    var actionableEnemyTiles: [Tile] = [Tile]()
    
    var tilesAdjacentNeutral: [Tile] = [Tile]()
    var tilesAdjacentEnemies: [Tile] = [Tile]()
    
    init(name: String, tileColor: SKColor, actionColor: SKColor, board: Board) {
        self.name = name
        self.tileColor = tileColor
        self.actionColor = actionColor
        self.board = board
        
        self.active = true
    }
    
    func prepareInfoAboutTiles() {
        
        actionableNeutralTiles.removeAll(keepCapacity: true)
        actionableEnemyTiles.removeAll(keepCapacity: true)
        tilesAdjacentNeutral.removeAll(keepCapacity: true)
        tilesAdjacentEnemies.removeAll(keepCapacity: true)
        
        for tile in tiles {
            if tile.neighbours.contains({$0.owner == nil}) {
                tilesAdjacentNeutral.append(tile)
                
                if tile.neighbours.contains({$0.owner !== self}) {
                    tilesAdjacentEnemies.append(tile)
                }
            }
        }
        
        for tile in tiles {
            for neighbourTile in tile.neighbours {
                if neighbourTile.owner == nil && !actionableNeutralTiles.contains({$0 === neighbourTile}) {
                    actionableNeutralTiles.append(neighbourTile)
                    
                } else if neighbourTile.owner !== self && !actionableEnemyTiles.contains({$0 === neighbourTile}) {
                    actionableEnemyTiles.append(neighbourTile)
                }
            }
        }
        
    }
    
}

class Human: Player {
    
    func actionStartIn(tile: Tile) -> Bool {
        
        if tile.owner != nil { return false }
        
        tile.owner = self
        tile.force = 3
        tiles.append(tile)
        
        return true
    }
    
    func actionReinforcementPre() -> Bool {
    
        self.reinforcements = UInt(max(2, self.tiles.count / 3))
        
        for tile in self.tiles {
            tile.shape.strokeColor = self.actionColor
            tile.actionable = true
        }
    
    }
    
    func actionReinforcementIn(tile: Tile) -> Bool {
        
        if tile.owner === self {
            tile.force += 1
            self.reinforcements -= 1
        }
        
        return reinforcements <= 0
        
    }
    
    func actionMovePre() -> Bool {
        
        for tile in tiles {
            tile.shape.strokeColor = actionColor
            tile.actionable = true
            for neighbourTile in tile.neighbours {
                neighbourTile.shape.strokeColor = actionColor
                neighbourTile.actionable = true
            }
        }
        
    }
    
    func actionMoveIn(tile: Tile) -> Bool {
        
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
        }
        
        return true
    }
    
}

class AI: Player {
    
    func actionStartPre() -> Bool {
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
    
    func actionReinforcementPre() -> Bool {
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
    
    func actionMovePre() -> Bool {
        
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
        
    }
    
}