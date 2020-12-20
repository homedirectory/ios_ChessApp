//
//  Coordinates.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 20.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


struct Coordinates {
    
    let row: Int
    let col: Int
    
    var sum: Int {
        return self.row + self.col
    }
    
}


extension Coordinates: Equatable {
    
    static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
