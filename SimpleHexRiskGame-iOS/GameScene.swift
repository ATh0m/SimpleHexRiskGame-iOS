//
//  GameScene.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/27/16.
//  Copyright (c) 2016 Tomasz Nanowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var board: Board! = nil
    
    var players: [Player] = [Player]()
    var currentPlayerIndex: Int = 0
    
    var state: State = .Undefined
    
    enum State {
        case Create(Condition), Start(Condition), Reinforcement(Condition), Move(Condition), Win(Condition), Undefined

        enum Condition {
            case Pre, In, Post
        }
    }
    
    var message: SKLabelNode! = nil
    var messageDescription: SKLabelNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        state = .Create(.Pre)
        
        board = Board(minTilesAmount: 10, maxTilesAmount: 20)
    }
    
    func splashScreen() -> [SKLabelNode] {
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let labelsConfig: [(String, CGVector, CGFloat, String)] = [ ("SimpleHexRiskGame", CGVector(dx: 0, dy: 130), 20, ""),
                                                                    ("Jest to prosta gra strategiczna na podstawie gry Ryzyko. Twoim celem jest wyeliminowanie przeciwnych graczy.", CGVector(dx: 0, dy: 70), 12, ""),
                                                                    ("Przejmuj neutralne i wrogie tereny, aby powiększać swoje wojska", CGVector(dx: 0, dy: 50), 12, ""),
                                                                    ("Po przejęciu pustego pola, jego wartość będzie równa średniej wartości sąsiadów", CGVector(dx: 0, dy: 30), 12, ""),
                                                                    ("Kiedy atakujesz worgie pole siła ataku wynosi połowę siły sąsiadujących przyjaciół", CGVector(dx: 0, dy: 10), 12, ""),
                                                                    ("Mapa i kolejność rozgrywki jest losowa", CGVector(dx: 0, dy: -10), 12, ""),
                                                                    ("Wybierz liczbę graczy, którzy wezmą udział w potyczce.", CGVector(dx: 0, dy: -50), 12, ""),
                                                                    ("Nad resztą kontrolę przejmie komputer. Powodzenia!", CGVector(dx: 0, dy: -70), 12, ""),
                                                                    ("0", CGVector(dx: -150, dy: -130), 20, "playersAmount: 0"),
                                                                    ("1", CGVector(dx: -75, dy: -130), 20, "playersAmount: 1"),
                                                                    ("2", CGVector(dx: 0, dy: -130), 20, "playersAmount: 2"),
                                                                    ("3", CGVector(dx: 75, dy: -130), 20, "playersAmount: 3"),
                                                                    ("4", CGVector(dx: 150, dy: -130), 20, "playersAmount: 4")]
        
        var labels: [SKLabelNode] = [SKLabelNode]()
        
        for (text, translation, fontSize, name) in labelsConfig {
            let label = SKLabelNode.init(fontNamed: "Helvetica Neue")
            label.fontColor = SKColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
            
            label.name = name
            label.text = text
            label.fontSize = fontSize
            label.position = center + translation
            
            label.verticalAlignmentMode = .Center
            label.horizontalAlignmentMode = .Center
            
            labels.append(label)
        }
        
        return labels
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            switch state {
                
            case .Create(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if let label = node as? SKLabelNode {
                        if ((label.name?.hasPrefix("playersAmount: ")) != nil) {
                            if let playersAmount: Int = Int(label.text!) {
                                
                                players.removeAll()
                                
                                if playersAmount >= 1 {
                                    players.append(Human(name: "Player1", tileColor: SKColor.redColor(), actionColor: SKColor.redColor()))
                                } else {
                                    players.append(AI(name: "Player1", tileColor: SKColor.redColor(), actionColor: SKColor.redColor()))
                                }
                                
                                if playersAmount >= 2 {
                                    players.append(Human(name: "Player2", tileColor: SKColor.blueColor(), actionColor: SKColor.blueColor()))
                                } else {
                                    players.append(AI(name: "Player2", tileColor: SKColor.blueColor(), actionColor: SKColor.blueColor()))
                                }
                                
                                if playersAmount >= 3 {
                                    players.append(Human(name: "Player3", tileColor: SKColor.greenColor(), actionColor: SKColor.greenColor()))
                                } else {
                                    players.append(AI(name: "Player3", tileColor: SKColor.greenColor(), actionColor: SKColor.greenColor()))
                                }
                                
                                if playersAmount >= 4 {
                                    players.append(Human(name: "Player4", tileColor: SKColor.purpleColor(), actionColor: SKColor.purpleColor()))
                                } else {
                                    players.append(AI(name: "Player4", tileColor: SKColor.purpleColor(), actionColor: SKColor.purpleColor()))
                                }
                                
                                srandom(UInt32(time(nil)))
                                
                                currentPlayerIndex = random() % players.count
                                
                                state = .Create(.Post)
                            }
                        }
                    }
                case .Post: break
                }
                
            case .Start(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    
                    if let tileShape = node as? Tile.TileShape {
                        
                        let player = players[currentPlayerIndex]
                        
                        if tileShape.tile.owner == nil {
                            tileShape.tile.owner = player
                            tileShape.tile.force = 3
                            player.tiles.append(tileShape.tile)
                            
                            state = .Start(.Post)
                        }
                    }
                    
                case .Post: break
                }
                
            case .Reinforcement(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    
                    if let tileShape = node as? Tile.TileShape {
                        let player = players[currentPlayerIndex]
                        
                        if player is Human {
                            if tileShape.tile.owner === player {
                                tileShape.tile.force += 1
                                player.reinforcements -= 1
                            }
                            
                            if player.reinforcements <= 0 {
                                state = .Reinforcement(.Post)
                            }
                        }
                    }
                    
                case .Post: break
                }
                
            case .Move(let condition):
                switch condition {
                case .Pre: break
                case .In:
                    if let tileShape = node as? Tile.TileShape {
                        
                        if tileShape.tile.actionable {
                        
                            let player = players[currentPlayerIndex]
                            
                            if tileShape.tile.owner === player {
                                
                                tileShape.tile.force += 2
                                
                            } else if tileShape.tile.owner == nil {
                                
                                var attackPower:UInt = 0
                                
                                for neighbourTile in tileShape.tile.neighbours {
                                    if neighbourTile.owner === player {
                                        attackPower += neighbourTile.force / 2
                                    }
                                }
                                
                                if attackPower <= 0 { break }
                                
                                tileShape.tile.owner = player
                                tileShape.tile.force = attackPower
                                
                                player.tiles.append(tileShape.tile)
                                
                            } else if !(tileShape.tile.owner === player) {
                                
                                var attackPower: UInt = 0
                                
                                for neighbourTile in tileShape.tile.neighbours {
                                    if neighbourTile.owner === player {
                                        attackPower += neighbourTile.force / 2
                                        neighbourTile.force -= neighbourTile.force / 2
                                    }
                                }
                                
                                var defensePower = tileShape.tile.force
                                
                                srandom(UInt32(time(nil)))
                                
                                while attackPower > 0 && defensePower > 0 {
                                    let attackDicesAmount = min(attackPower, 3)
                                    let defenseDicesAmount = min(defensePower, 2)
                                    
                                    var attackDices = [Int]()
                                    var defenseDices = [Int]()
                                    
                                    for _ in 0..<attackDicesAmount {
                                        attackDices.append(1 + random() % 6)
                                    }
                                    
                                    for _ in 0..<defenseDicesAmount {
                                        defenseDices.append(1 + random() % 6)
                                    }
                                    
                                    attackDices = attackDices.sort({$0 > $1})
                                    defenseDices = defenseDices.sort({$0 > $1})
                                    
                                    for i in 0..<Int(min(attackDicesAmount, defenseDicesAmount)) {
                                        if attackDices[i] > defenseDices[i] {
                                            defensePower -= 1
                                        } else {
                                            attackPower -= 1
                                        }
                                    }
                                }
                                
                                if attackPower > 0 {
                                    
                                    let opponent: Player! = tileShape.tile.owner
                                    
                                    let index = opponent.tiles.indexOf({$0 === tileShape.tile})
                                    opponent.tiles.removeAtIndex(index!)
                                    
                                    player.tiles.append(tileShape.tile)
                                    tileShape.tile.owner = player
                                    tileShape.tile.force = attackPower
                                    
                                    if opponent.tiles.count == 0 {
                                        opponent.active = false
                                    }
                                    
                                } else {
                                    tileShape.tile.force = defensePower
                                }
                                
                            } else { break }
                            
                            
                            state = .Move(.Post)
                        }
                    }
                case .Post: break
                }
                
            case .Win(let condition):
                switch condition {
                case .Pre: break
                case .In: break
                case .Post: break
                }
                
            default: break
            }
        
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        switch state {
            
        case .Create(let condition):
            switch condition {
            case .Pre:
                for label in splashScreen() {
                    self.addChild(label)
                }
                
                state = .Create(.In)
            case .In: break
            case .Post:
                self.removeAllChildren()
                
                for tile in board.tiles {
                    self.addChild(tile.shape)
                }
                
                message = SKLabelNode(fontNamed: "Helvetica Neue")
                message.text = ""
                message.fontSize = 20
                message.color = SKColor.clearColor()
                message.position = CGPoint(x: size.width / 2, y: 45 )
                self.addChild(message)
                
                messageDescription = SKLabelNode(fontNamed: "Helvetica Neue")
                messageDescription.text = ""
                messageDescription.fontSize = 12
                messageDescription.color = SKColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                messageDescription.position = CGPoint(x: size.width / 2, y: 20 )
                self.addChild(messageDescription)
                
                state = .Start(.Pre)
            }
            
        case .Start(let condition):
            switch condition {
            case .Pre:
                
                let player = players[currentPlayerIndex]
                
                if player.tiles.count > 0 {
                    state = .Reinforcement(.Pre)
                    break
                }
                
                if player is AI {
                    
                    srandom(UInt32(time(nil)))
                    
                    var tile = board.tiles[random() % board.tiles.count]
                    
                    while tile.owner != nil {
                        tile = board.tiles[random() % board.tiles.count]
                    }
                    
                    tile.owner = player
                    tile.force = 3
                    player.tiles.append(tile)
                    
                    state = .Start(.Post)
                    break
                }
                
                message.text = "Gracz \(player.name) wybierz swoje startowe pole"
                message.fontColor = players[currentPlayerIndex].tileColor
                messageDescription.text = "Wybierz dowolne wolne pole jako twój startowy teren"
                
                for tile in board.tiles {
                    if tile.owner == nil {
                        tile.shape.strokeColor = player.actionColor
                        tile.actionable = true
                    }
                }
                
                state = .Start(.In)
                
            case .In: break
                
            case .Post:
                
                for tile in board.tiles {
                    tile.shape.strokeColor = SKColor.clearColor()
                    tile.actionable = false
                }
                
                currentPlayerIndex = (currentPlayerIndex + 1) % players.count
                state = .Start(.Pre)
            }
            
        case .Reinforcement(let condition):
            switch condition {
            case .Pre:
                let player = players[currentPlayerIndex]
                
                player.reinforcements = UInt(max(2, player.tiles.count / 3))
                
                message.text = "Gracz \(player.name) rozstaw swoje siły. Pozostało \(player.reinforcements)"
                message.fontColor = players[currentPlayerIndex].tileColor
                messageDescription.text = "Wybierz swoje pole, które chcesz wzmocnić. Kliknięcie prawym przyciskiem dodaje wszystkie jednostki"
                
                if player is Human {
                    for tile in player.tiles {
                        tile.shape.strokeColor = player.actionColor
                        tile.actionable = true
                    }
                }
                
                if player is AI {
                    
                    var tilesAdjacentNeutral: [Tile] = [Tile]()
                    var tilesAdjacentEnemies: [Tile] = [Tile]()
                    
                    for tile in player.tiles {
                        if tile.neighbours.contains({$0.owner == nil}) {
                            tilesAdjacentNeutral.append(tile)
                        }
                        
                        if tile.neighbours.contains({!($0.owner === player || $0.owner == nil)}) {
                            tilesAdjacentEnemies.append(tile)
                        }
                    }
                    
                    srand48(time(nil))
                    srandom(UInt32(time(nil)))
                    
                    var tile: Tile
                    
                    while player.reinforcements > 0 {
                        if tilesAdjacentEnemies.count > 0 && (drand48() < 0.75 || tilesAdjacentNeutral.count == 0) {
                            tile = tilesAdjacentEnemies[random() % tilesAdjacentEnemies.count]
                        } else if tilesAdjacentNeutral.count > 0 {
                            tile = tilesAdjacentNeutral[random() % tilesAdjacentNeutral.count]
                        } else {
                            tile = player.tiles[random() % player.tiles.count]
                        }
                        
                        tile.force += 1
                        player.reinforcements -= 1
                        
                    }
                    
                    state = .Reinforcement(.Post)
                    break
                }
                
                state = .Reinforcement(.In)
                
            case .In:
                
                let player = players[currentPlayerIndex]
                
                message.text = "Gracz \(player.name) rozstaw swoje siły. Pozostało \(player.reinforcements)"
                
            case .Post:
                
                let player = players[currentPlayerIndex]
                
                for tile in player.tiles {
                    tile.shape.strokeColor = SKColor.clearColor()
                    tile.actionable = false
                }
                
                state = .Move(.Pre)
            }
            
        case .Move(let condition):
            switch condition {
            case .Pre:
                let player = players[currentPlayerIndex]
                
                message.text = "Gracz \(player.name) wykonaj ruch"
                message.fontColor = players[currentPlayerIndex].tileColor
                messageDescription.text = "Dołącz neutralne pole, zaatakuj przeciwnika lub wzmocnij swój teren 2 jednostkami"
                
                if player is Human {
                    for tile in player.tiles {
                        tile.shape.strokeColor = player.actionColor
                        tile.actionable = true
                        for neighbourTile in tile.neighbours {
                            neighbourTile.shape.strokeColor = player.actionColor
                            neighbourTile.actionable = true
                        }
                    }
                }
                
                if player is AI {
                    state = .Move(.Post)
                    break
                }
                
                state = .Move(.In)
            case .In: break
            case .Post:
                
                let player = players[currentPlayerIndex]
                
                for tile in player.tiles {
                    tile.shape.strokeColor = SKColor.clearColor()
                    tile.actionable = false
                    for neighbourTile in tile.neighbours {
                        neighbourTile.shape.strokeColor = SKColor.clearColor()
                        neighbourTile.actionable = false
                    }
                }
                
                repeat {
                    currentPlayerIndex = (currentPlayerIndex + 1) % players.count
                } while !players[currentPlayerIndex].active
                
                state = .Reinforcement(.Pre)
            }
            
        case .Win(let condition):
            switch condition {
            case .Pre: break
            case .In: break
            case .Post: break
            }

        default: break
        }
    }
}
