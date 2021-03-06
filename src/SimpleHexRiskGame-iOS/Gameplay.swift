//
//  Gameplay.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 6/1/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/// Klasa do zarządzania całą rozgrywką
class Gameplay {
    
    /// Dostęp do planszy
    var board: Board!
    /// Dostęp do widoku gry
    var gameScene: GameScene!
    
    /// Lista graczy
    var players: [Player] = [Player]()
    /// Indeks obecnego gracza w liście graczy
    var currentPlayerIndex: Int = 0
    
    /// Obecny stan gry
    var state: State = .Undefined
    
    /**
     Stany gry
     
     - Create:        Wyświetlenie ekranu startowego i tworzenie nowej rozgrywki
     - Start:         Tura, kiedy gracze wybierają ich startowe pola
     - Reinforcement: Tura, kiedy gracze wzmacniają swoje pola
     - Move:          Tura, kiedy gracze mogą zaatakować inne pole lub wzmocnić swoje
     - Win:           Koniec gry i wyświetlenie zwycięzcy
     - Undefined:     Niezdefiniowany stan
     
     - Condition:     Podział stanu na 3 części (Pre, In, Post)
     */
    enum State {
        /** Wyświetlenie ekranu startowego i tworzenie nowej rozgrywki */
        case Create(Condition)
        /** Tura, kiedy gracze wybierają ich startowe pola */
        case Start(Condition)
        /** Tura, kiedy gracze wzmacniają swoje pola */
        case Reinforcement(Condition)
        /** Tura, kiedy gracze mogą zaatakować inne pole lub wzmocnić swoje */
        case Move(Condition)
        /** Koniec gry i wyświetlenie zwycięzcy*/
        case Win(Condition)
        /** Niezdefiniowany stan */
        case Undefined
        
        /**
         Podział stanu na 3 części (Pre, In, Post)
         
         - Pre:  W tej części wykonywane są akcje przed stanem
         - In:   W tej części wykonywane są akcje w trakcie stanu
         - Post: W tej części wykonywane są akcje po stanie
         */
        enum Condition {
            /** W tej części wykonywane są akcje przed stanem */
            case Pre
            /** W tej części wykonywane są akcje w trakcie stanu */
            case In
            /** W tej części wykonywane są akcje po stanie */
            case Post
        }
    }
    
    /**
     Tworzenie nowej rozgrywki
     */
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        board = Board(minTilesAmount: 5, maxTilesAmount: 30)
        state = .Create(.Pre)
    }
    
    /**
     Akcja do wykonania przed stanem Create
     */
    func actionCreatePre() -> Bool {
        
        let center = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        
        let labelsConfig: [(String, CGVector, CGFloat)] = [ ("SimpleHexRiskGame".uppercaseString, CGVector(dx: 0, dy: 130), 20),
                                                            ("Jest to prosta gra strategiczna na podstawie gry Ryzyko. Twoim celem jest wyeliminowanie przeciwnych graczy.", CGVector(dx: 0, dy: 70), 12),
                                                            ("Przejmuj neutralne i wrogie tereny, aby powiększać swoje wojska", CGVector(dx: 0, dy: 50), 12),
                                                            ("Po przejęciu pustego pola, jego wartość będzie równa średniej wartości sąsiadów", CGVector(dx: 0, dy: 30), 12),
                                                            ("Kiedy atakujesz worgie pole siła ataku wynosi połowę siły sąsiadujących przyjaciół", CGVector(dx: 0, dy: 10), 12),
                                                            ("Mapa i kolejność rozgrywki jest losowa", CGVector(dx: 0, dy: -10), 12),
                                                            ("Wybierz liczbę graczy, którzy wezmą udział w potyczce.", CGVector(dx: 0, dy: -50), 12),
                                                            ("Nad resztą kontrolę przejmie komputer. Powodzenia!", CGVector(dx: 0, dy: -70), 12)]
        
        let choicesConfig: [(String, CGVector, CGFloat, String)] = [ ("0", CGVector(dx: -150, dy: -130), 20, "0"),
                                                                     ("1", CGVector(dx: -75, dy: -130), 20, "1"),
                                                                     ("2", CGVector(dx: 0, dy: -130), 20, "2"),
                                                                     ("3", CGVector(dx: 75, dy: -130), 20, "3"),
                                                                     ("4", CGVector(dx: 150, dy: -130), 20, "4")]
        
        var labels: [SKLabelNode] = [SKLabelNode]()
        
        for (text, translation, fontSize) in labelsConfig {
            let label = SKLabelNode(fontNamed: "Helvetica Neue")
            label.fontColor = SKColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
            
            label.text = text
            label.fontSize = fontSize
            label.position = center + translation
            
            label.verticalAlignmentMode = .Center
            label.horizontalAlignmentMode = .Center
            
            labels.append(label)
        }
        
        for label in labels {
            gameScene.addChild(label)
        }
        
        for (text, translation, fontSize, name) in choicesConfig {
            let box = SKShapeNode(rectOfSize: CGSize(width: 50, height: 50))
            box.position = center + translation
            box.lineWidth = 0
            box.fillColor = SKColor.clearColor()
            box.name = name
            gameScene.addChild(box)
            
            let label = SKLabelNode(fontNamed: "Helvetica Neue")
            label.fontColor = SKColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
            label.text = text
            label.fontSize = fontSize
            label.position = CGPointZero
            
            label.verticalAlignmentMode = .Center
            label.horizontalAlignmentMode = .Center
            
            box.addChild(label)
        }
        
        return true
    }
    
    /**
     Akcja do wykonania w trakcie stanu Create
     */
    func actionCreateIn(nodes: [SKNode]) -> Bool {
        
        for node in nodes {
            if let label = node as? SKShapeNode {
                if let playersAmount: Int = Int(label.name!) {
                    
                    players.removeAll()
                    
                    if playersAmount >= 1 {
                        players.append(Human(name: "CZERWONY", tileColor: SKColor.redColor(), actionColor: SKColor.redColor(), game: self))
                    } else {
                        players.append(AI(name: "CZERWONY", tileColor: SKColor.redColor(), actionColor: SKColor.redColor(), game: self))
                    }
                    
                    if playersAmount >= 2 {
                        players.append(Human(name: "NIEBIESKI", tileColor: SKColor.blueColor(), actionColor: SKColor.blueColor(), game: self))
                    } else {
                        players.append(AI(name: "NIEBIESKI", tileColor: SKColor.blueColor(), actionColor: SKColor.blueColor(), game: self))
                    }
                    
                    if playersAmount >= 3 {
                        players.append(Human(name: "ZIELONY", tileColor: SKColor.greenColor(), actionColor: SKColor.greenColor(), game: self))
                    } else {
                        players.append(AI(name: "ZIELONY", tileColor: SKColor.greenColor(), actionColor: SKColor.greenColor(), game: self))
                    }
                    
                    if playersAmount >= 4 {
                        players.append(Human(name: "FIOLETOWY", tileColor: SKColor.purpleColor(), actionColor: SKColor.purpleColor(), game: self))
                    } else {
                        players.append(AI(name: "FIOLETOWY", tileColor: SKColor.purpleColor(), actionColor: SKColor.purpleColor(), game: self))
                    }
                    
                    srandom(UInt32(time(nil)))
                    
                    currentPlayerIndex = random() % players.count
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    /**
     Akcja do wykonania po stanie Create
     */
    func actionCreatePost() -> Bool {
        gameScene.removeAllChildren()
        
        let tileSize: CGFloat = 30
        let tileTranslation = CGVector(dx: (gameScene.self.size.width - board.size.width * tileSize) / 2.0,
                                       dy: (gameScene.self.size.height - board.size.height * tileSize - 60) / 2.0 + 60)
        
        for tile in board.tiles {
            tile.createShape(tileSize, translation: tileTranslation)
            gameScene.addChild(tile.shape)
        }
        
        gameScene.message = SKLabelNode(fontNamed: "Helvetica Neue")
        gameScene.message.text = ""
        gameScene.message.fontSize = 20
        gameScene.message.color = SKColor.clearColor()
        gameScene.message.position = CGPoint(x: gameScene.size.width / 2, y: 45 )
        gameScene.addChild(gameScene.message)
        
        gameScene.messageDescription = SKLabelNode(fontNamed: "Helvetica Neue")
        gameScene.messageDescription.text = ""
        gameScene.messageDescription.fontSize = 12
        gameScene.messageDescription.color = SKColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        gameScene.messageDescription.position = CGPoint(x: gameScene.size.width / 2, y: 20 )
        gameScene.addChild(gameScene.messageDescription)
        
        gameScene.winMessageBox = SKShapeNode(rectOfSize: CGSize(width: gameScene.size.width, height: 70))
        gameScene.winMessageBox.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 )
        gameScene.winMessageBox.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        gameScene.winMessageBox.lineWidth = 0
        gameScene.winMessageBox.zPosition = 1000
        gameScene.winMessageBox.hidden = true
        gameScene.addChild(gameScene.winMessageBox)
        
        
        gameScene.winMessage = SKLabelNode(fontNamed: "Helvetica Neue")
        gameScene.winMessage.text = ""
        gameScene.winMessage.fontSize = 20
        gameScene.winMessage.zPosition = 1001
        gameScene.winMessage.fontColor = SKColor.clearColor()
        gameScene.winMessage.position = CGPoint(x: 0, y: 0)
        gameScene.winMessage.verticalAlignmentMode = .Center
        gameScene.winMessage.horizontalAlignmentMode = .Center
        gameScene.winMessageBox.addChild(gameScene.winMessage)
        
        return true
    }
    
    /**
     Akcja do wykonania przed stanem Create
     */
    func actionStartPre() -> Bool {
        
        let player = players[currentPlayerIndex]
        
        gameScene.message.text = "Gracz \(player.name) wybierz swoje startowe pole"
        gameScene.message.fontColor = players[currentPlayerIndex].tileColor
        gameScene.messageDescription.text = "Wybierz dowolne wolne pole jako twój startowy teren"
        
        for tile in board.tiles {
            if tile.owner == nil {
                tile.shape.strokeColor = player.actionColor
                tile.actionable = true
            }
        }

        return true
    }
    
    /**
     Akcja do wykonania w trakcie stanu Start
     */
    func actionStartIn() -> Bool {
        return true
    }
    
    /**
     Akcja do wykonania po stanie Start
     */
    func actionStartPost() -> Bool {
        for tile in board.tiles {
            tile.shape.strokeColor = SKColor.clearColor()
            tile.actionable = false
        }
        
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        
        return true
    }
    
    /**
     Akcja do wykonania przed stanem Reinforcement
     */
    func actionReinforcementPre() -> Bool {
        
        let player = players[currentPlayerIndex]
        
        gameScene.message.text = "Gracz \(player.name) rozstaw swoje siły. Pozostało \(player.reinforcements)"
        gameScene.message.fontColor = players[currentPlayerIndex].tileColor
        gameScene.messageDescription.text = "Wybierz swoje pole, które chcesz wzmocnić"
        
        return true
        
    }
    
    /**
     Akcja do wykonania w trakcie stanu Reinforcement
     */
    func actionReinforcementIn() -> Bool {
        
        let player = players[currentPlayerIndex]
        
        gameScene.message.text = "Gracz \(player.name) rozstaw swoje siły. Pozostało \(player.reinforcements)"
        
        return true
        
    }
    
    /**
     Akcja do wykonania po stanie Reinforcement
     */
    func actionReinforcementPost() -> Bool {
        
        let player = players[currentPlayerIndex]
        
        for tile in player.tiles {
            tile.shape.strokeColor = SKColor.clearColor()
            tile.actionable = false
        }
        
        return true
    
    }
    
    /**
     Akcja do wykonania przed stanem Move
     */
    func actionMovePre() -> Bool {
    
        let player = players[currentPlayerIndex]
        
        gameScene.message.text = "Gracz \(player.name) wykonaj ruch"
        gameScene.message.fontColor = players[currentPlayerIndex].tileColor
        gameScene.messageDescription.text = "Dołącz neutralne pole, zaatakuj przeciwnika lub wzmocnij swój teren 2 jednostkami"
        
        
        return true
    }
    
    /**
     Akcja do wykonania w trakcie stanu Move
     */
    func actionMoveIn() -> Bool {
        return true
    }
    
    /**
     Akcja do wykonania po stanie Move
     */
    func actionMovePost() -> Bool {
    
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
        
        return true
    
    }
    
    /**
     Akcja do wykonania przed stanem Win
     */
    func actionWinPre() -> Bool {
        
        if let index = players.indexOf({$0.active}) {
            let player = players[index]
            
            gameScene.winMessage.text = "Gracz \(player.name.uppercaseString) wygrał. Kliknij, aby zacząć od nowa"
            gameScene.winMessage.fontColor = player.actionColor
            gameScene.winMessageBox.hidden = false
            
            return true
        }
        
        return false
    }
    
    /**
     Akcja do wykonania po stanie Win
     */
    func actionWinPost() -> Bool {
        
        gameScene.removeAllChildren()
        board = Board(minTilesAmount: 5, maxTilesAmount: 30)
        
        return true
    }
}













