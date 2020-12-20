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
        var coordinates = [Coordinates(row: self.row + self.isWhiteSign, col :self.col), Coordinates(row: self.row + self.isWhiteSign, col: self.col + 1), Coordinates(row: self.row + self.isWhiteSign, col: self.col - 1)]
        if !self.moved {
            coordinates.append(Coordinates(row: self.row + (2 * self.isWhiteSign), col: self.col))
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
