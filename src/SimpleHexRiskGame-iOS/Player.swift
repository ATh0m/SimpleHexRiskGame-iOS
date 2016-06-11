//
//  Player.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/29/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/// Klasa zawierająca informacje o graczu i jego akcje
class Player {
    
    /// Nazwa gracza
    var name: String = ""
    
    /// Informacja o tym czy gracz jest aktywny (czy nie został jeszcze wyeliminowany)
    var active: Bool = false
    
    /// Kolor pól gracza
    var tileColor: SKColor
    /// Kolor akcji gracza
    var actionColor: SKColor
    
    /// Ilość jednostek, którymi gracz może wzmocnić swoje pola
    var reinforcements: UInt = 0
    
    /// Dostęp do całej rozgrywki
    var game: Gameplay
    
    /// Lista pól, które należą do gracza
    var tiles: [Tile] = [Tile]()
    
    /// Lista neutralnych pól, na których gracz może wykonać akcje
    var actionableNeutralTiles: [Tile] = [Tile]()
    /// Lista wrogich pól, na których gracz może wykonać akcje
    var actionableEnemyTiles: [Tile] = [Tile]()
    
    /// Lista neutralnych, graniczących pól
    var tilesAdjacentNeutral: [Tile] = [Tile]()
    /// Lista wrogich, graniczących pól
    var tilesAdjacentEnemies: [Tile] = [Tile]()
    
    /**
     Tworzenie nowego gracza
     
     - parameter name:        Nazwa gracza
     - parameter tileColor:   Kolor pól gracza
     - parameter actionColor: Kolor akcji gracza
     - parameter game:        Wskaźnik na rozgrywkę
     */
    init(name: String, tileColor: SKColor, actionColor: SKColor, game: Gameplay) {
        self.name = name
        self.tileColor = tileColor
        self.actionColor = actionColor
        self.game = game
        
        self.active = true
    }
    
    /**
     Aktualizuje listę graniczących pól i tych, na których gracz może wykonać akcje
     
     - tilesAdjacentNeutral
     - tilesAdjacentEnemies
     - actionableNeutralTiles
     - actionableEnemyTiles
     */
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
    
    /**
     Akcja do wykonania przed stanem Start
     */
    func actionStartPre() -> Bool { return true }
    /**
     Akcja do wykonania w trakcie stanu Start
     */
    func actionStartIn(nodes: [SKNode]) -> Bool { return true }
    /**
     Akcja do wykonania przed stanem Reinforcement
     */
    func actionReinforcementPre() -> Bool { return true }
    /**
     Akcja do wykonania w trakcie stanu Reinforcement
     */
    func actionReinforcementIn(nodes: [SKNode]) -> Bool { return true }
    /**
     Akcja do wykonania przed stanem Move
     */
    func actionMovePre() -> Bool { return true }
    /**
     Akcja do wykonania w trakcie stanu Move
     */
    func actionMoveIn(nodes: [SKNode]) -> Bool { return true }
    
}
