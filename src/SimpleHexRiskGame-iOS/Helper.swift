//
//  Helper.swift
//  SimpleHexRiskGame-iOS
//
//  Created by Tomasz Nanowski on 5/29/16.
//  Copyright © 2016 Tomasz Nanowski. All rights reserved.
//

import Foundation
import SpriteKit

/**
 * Dodanie CGVector do CGPoint i zwrócenie wyniku jako nowy CGPoint
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Zwiększenie wartości CGPoint o CGVector
 */
public func += (inout left: CGPoint, right: CGVector) {
    left = left + right
}








