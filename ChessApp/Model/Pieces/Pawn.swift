//
//  Pawn.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Pawn: Piece {
        
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [Coordinates] {
        var coordinates = [self.coordinates.addRows(self.isWhiteSign), self.coordinates.addRows(self.isWhiteSign).addColumns(1), self.coordinates.addRows(self.isWhiteSign).addColumns(-1)]
        if !self.moved {
            coordinates.append(self.coordinates.addRows(2 * self.isWhiteSign))
        }
        return coordinates
    }
    
    func isValidMoveBySpecialRules(_ move: Move, toSquareIsEmpty: Bool) -> Bool {
        // pawns can't move diagonally to an empty square
        if move.isDiagonal {
            if toSquareIsEmpty {
                return false
            }
        }
        // pawns can't eat on a straight line
        else {
            if !toSquareIsEmpty {
                return false
            }
        }
        
        return true
    }
    
}
