//
//  Battle.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 6/1/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation

class Battle {
    
    static func battle(attack: UInt, defense: UInt) -> (leftAttack: UInt, leftDefense: UInt) {
        
        srandom(UInt32(time(nil)))
        
        var attackPower = attack
        var defensePower = defense
        
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
        
        return (attackPower, defensePower)
    }
    
}