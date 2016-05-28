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
    
    var size: CGSize = CGSizeZero
    
    init(size: CGSize) {
        
        self.size = size
        
        
        
    }

}


class MapGenerator {
    
    static let odd: [[Int]] = [[0, -1], [1, -1], [1,  0], [1,  1], [0,  1], [-1, 0]]
    static let even: [[Int]] = [[-1, -1], [0,  -1], [1,  0], [0,  1], [-1, 1], [-1, 0]]
    
    
    class func generateMap(size: CGSize, rate: CGFloat) -> [[Int]] {
        
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        var blankFieldsAmount: Int = Int(size.width * size.height * rate)
        blankFieldsAmount = Int(arc4random()) % blankFieldsAmount
        
        var map = [[Int]](count: width, repeatedValue: [Int](count: height, repeatedValue: 0))
        
        while blankFieldsAmount > 0 {
            let x: Int = Int(arc4random()) % width
            let y: Int = Int(arc4random()) % height
            
            if map[x][y] != -1 {
                map[x][y] = -1
                blankFieldsAmount -= 1
            }
        }
        
        printMap(&map, size: size)
        
        let different: Int = colorMap(&map, size: size) - 1
        
        if different > 1 {
            fixMap(&map, size: size)
        }
        
        printMap(&map, size: size)
        
        formatMap(&map, size: size)
        
        printMap(&map, size: size)
        
        return map
    }
    
    class func fixMap(inout map: [[Int]], size: CGSize) {
        
        while normalizeMap(&map, size: size) != 0 {
            colorMap(&map, size: size)
        }
        
        let different: Int = colorMap(&map, size: size) - 1
        
        printMap(&map, size: size)
        
        if different > 1 {
            var maxAmount: Int = 0
            var maxColor: Int = 1
            var amount: Int = 0
            
            for i in 1...different {
                amount = countFieldsColor(&map, size: size, color: i)
                if amount > maxAmount {
                    maxColor = i
                    maxAmount = amount
                }
            }
            
            eraceAnotherColors(&map, size: size, color: maxColor)
        }
        
    }
    
    class func eraceAnotherColors(inout map: [[Int]], size: CGSize, color: Int) {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        for x in 0..<width {
            for y in 0..<height {
                if map[x][y] != -1 && map[x][y] != color {
                    map[x][y] = -1
                }
            }
        }
    }
    
    class func countFieldsColor(inout map: [[Int]], size: CGSize, color: Int) -> Int {
        
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        var counter: Int = 0
        
        for x in 0..<width {
            for y in 0..<height {
                if map[x][y] == color {
                    counter += 1
                }
            }
        }
        
        return counter
    }
    
    class func normalizeMap(inout map: [[Int]], size: CGSize) -> Int {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        var counter: Int = 0
        
        for x in 0..<width {
            for y in 0..<height {
                if map[x][y] == -1 {
                    if countDifferentFields(&map, size: size, point: CGPoint(x: x, y: y)) > 1 {
                        map[x][y] = 0
                        counter += 1
                    }
                }
            }
        }
        
        for x in 0..<width {
            for y in 0..<height {
                map[x][y] = map[x][y] >= 0 ? 0 : -1
            }
        }
        
        return counter
    }
    
    
    class func countDifferentFields(inout map: [[Int]], size: CGSize, point: CGPoint) -> Int {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        let x: Int = Int(point.x)
        let y: Int = Int(point.y)
        
        var X, Y: Int
        var counter: Int = 0
        var color: Int = 0
        
        for i in 0..<6 {
            if y % 2 == 0 {
                X = x + even[i][0];
                Y = y + even[i][1];
            }
            else {
                X = x + odd[i][0];
                Y = y + odd[i][1];
            }
            
            if X >= 0 && Y >= 0 && X < width && Y < height {
                if map[X][Y] != 0 && map[X][Y] != -1 && map[X][Y] != color {
                    color = map[X][Y]
                    counter += 1
                }
            }
        }
        
        return counter
    }
    
    class func colorMap(inout map: [[Int]], size: CGSize) -> Int {
        
        var color:Int = 1
        
        let width:Int = Int(size.width)
        let height:Int = Int(size.height)
        
        for x in 0 ..< width {
            for y in 0 ..< height {
                if map[x][y] == 0 {
                    colorFields(&map, size: size, point: CGPoint(x: x, y: y), color: color)
                    color += 1
                }
            }
        }
        
        return color
    }
    
    class func colorFields(inout map: [[Int]], size: CGSize, point: CGPoint, color: Int) {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        let x: Int = Int(point.x)
        let y: Int = Int(point.y)
        
        if x >= 0 && y >= 0 && x < width && y < height {
            if map[x][y] == 0 {
                map[x][y] = color
                
                var X, Y: Int
                
                for i in 0..<6 {
                    if y % 2 == 0 {
                        X = x + even[i][0]
                        Y = y + even[i][1];
                    }
                    else {
                        X = x + odd[i][0];
                        Y = y + odd[i][1];
                    }
                    
                    colorFields(&map, size: size, point: CGPoint(x: X, y: Y), color: color)
                }
            }
        }
        
    }
    
    class func formatMap(inout map: [[Int]], size: CGSize) {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        for x in 0..<width {
            for y in 0..<height {
                map[x][y] = map[x][y] < 0 ? 0 : 1
            }
        }
    }
    
    class func printMap(inout map: [[Int]], size: CGSize) {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)
        
        print()
        for x in 0..<width {
            for y in 0..<height {
                print(String(format: "%2d", map[x][y]), terminator: " ")
            }
            print()
        }
        
    }
}












