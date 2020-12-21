//
//  Queen.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Queen: Piece {
    
    override var name: String {
        return "queen"
    }
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [Coordinates] {
        var coordinates: [Coordinates] = []
        coordinates.append(contentsOf: self.getCoordinatesOnDiagonals())
        coordinates.append(contentsOf: self.getCoordinatesOnStraightLines())
        return coordinates
    }
    
    override func makeCopy() -> Queen {
        let piece = Queen(isWhite: self.isWhite)
        piece.moved = self.moved
        piece.potentialCheck = self.potentialCheck
        piece.coordinates = self.coordinates
        piece.dead = self.dead
        
        return piece
    }
    
    
}
