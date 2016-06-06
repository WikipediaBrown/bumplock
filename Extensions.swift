//
//  Extensions.swift
//  sinnerbro
//
//  Created by Perris Davis on 1/11/16.
//  Copyright © 2016 Perris Davis. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat(Float(arc4random()) /  0xFFFFFFFF) * (max - min) + min
    }
}