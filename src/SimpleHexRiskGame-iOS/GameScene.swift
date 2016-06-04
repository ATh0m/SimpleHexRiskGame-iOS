//
//  GameScene.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright (c) 2016 Tomasz Nanowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game: Gameplay!
    
    var message: SKLabelNode! = nil
    var messageDescription: SKLabelNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        game = Gameplay(gameScene: self)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let player: Player! = game.players.isEmpty ? nil : game.players[game.currentPlayerIndex]
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let nodes = nodesAtPoint(location)
        
            switch game.state {
            case .Create(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if game.actionCreateIn(nodes) { game.state = .Create(.Post) }
                case .Post: break
                }
            case .Start(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if player is Human {
                        if player.actionStartIn(nodes) { game.state = .Start(.Post) }
                    }
                case .Post: break
                }
            case .Reinforcement(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if player is Human {
                        if player.actionReinforcementIn(nodes) { game.state = .Reinforcement(.Post) }
                    }
                case .Post: break
                }
            case .Move(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if player is Human {
                        if player.actionMoveIn(nodes) { game.state = .Move(.Post) }
                    }
                case .Post: break
                }
            case .Win(let condition):
                switch condition {
                case .Pre: break
                case .In: break
                case .Post: break
                }
            case .Undefined: break
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        let player: Player! = game.players.isEmpty ? nil : game.players[game.currentPlayerIndex]
        
        switch game.state {
        case .Create(let condition):
            switch condition {
            case .Pre:
                if game.actionCreatePre() { game.state = .Create(.In) }
            case .In: break
            case .Post:
                if game.actionCreatePost() { game.state = .Start(.Pre) }
            }
        case .Start(let condition):
            switch condition {
            case .Pre:
                if game.actionStartPre() {
                    if player is AI {
                        if player.actionStartPre() { game.state = .Start(.Post) }
                        
                    } else { game.state = .Start(.In) }
                }
            case .In: break
            case .Post:
                if game.actionStartPost() {
                    if game.players[game.currentPlayerIndex].tiles.isEmpty { game.state = .Start(.Pre) }
                    else { game.state = .Reinforcement(.Pre) }
                }
            }
        case .Reinforcement(let condition):
            switch condition {
            case .Pre:
                if game.actionReinforcementPre() {
                    if player.actionReinforcementPre() {
                        if player is AI { game.state = .Reinforcement(.Post) }
                        else { game.state = .Reinforcement(.In) }
                    }
                }
            case .In:
                game.actionReinforcementIn()
            case .Post:
                if game.actionReinforcementPost() { game.state = .Move(.Pre) }
            }
        case .Move(let condition):
            switch condition {
            case .Pre:
                if game.actionMovePre() {
                    if player.actionMovePre() {
                        if player is AI { game.state = .Move(.Post) }
                        else { game.state = .Move(.In) }
                    }
                }
            case .In: break
            case .Post:
                if game.actionMovePost() { game.state = .Reinforcement(.Pre) }
            }
        case .Win(let condition):
            switch condition {
            case .Pre: break
            case .In: break
            case .Post: break
            }
        case .Undefined: break
        }
        
    }
}
