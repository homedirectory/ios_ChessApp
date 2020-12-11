//
//  Queen.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Queen: Piece {
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [[Int]] {
        var coordinates: [[Int]] = []
        coordinates.append(contentsOf: self.getCoordinatesOnDiagonals())
        coordinates.append(contentsOf: self.getCoordinatesOnStraightLines())
        return coordinates
    }
    
    
}
