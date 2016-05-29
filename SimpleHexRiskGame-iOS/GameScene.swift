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
                        tileShape.tile.force += 1
                        
                        for tile in tileShape.tile.neighbours {
                            tile.shape.fillColor = SKColor.greenColor()
                        }
                    }
                case .Post: break
                }
                
            case .Reinforcement(let condition):
                switch condition {
                case .Pre: break
                case .In: break
                case .Post: break
                }
                
            case .Move(let condition):
                switch condition {
                case .Pre: break
                case .In: break
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
                
                message.text = "Gracz \(players[currentPlayerIndex].name) wybierz swoje startowe pole"
                message.fontColor = players[currentPlayerIndex].tileColor
                messageDescription.text = "Wybierz dowolne wolne pole jako twój startowy teren"
                
                state = .Start(.In)
            case .In: break
            case .Post: break
            }
            
        case .Reinforcement(let condition):
            switch condition {
            case .Pre: break
            case .In: break
            case .Post: break
            }
            
        case .Move(let condition):
            switch condition {
            case .Pre: break
            case .In: break
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
