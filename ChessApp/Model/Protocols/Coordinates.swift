//
//  Coordinates.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


protocol Coordinates {
    
    var coordinates: [Int] { get set }
    var row: Int { get }
    var col: Int { get }
    
}

extension Coordinates {
    
    var row: Int {
        get {
            return coordinates[0]
        }
    }
    
    var col: Int {
        get {
            return coordinates[1]
        }
    }
}
