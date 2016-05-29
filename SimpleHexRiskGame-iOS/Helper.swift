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
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}








