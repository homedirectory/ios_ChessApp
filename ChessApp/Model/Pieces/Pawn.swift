//
//  Pawn.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Pawn: Piece {
    
    override var name: String {
        return "pawn"
    }
        
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
    
    func isValidMoveBySpecialRules(_ move: Move, toSquareIsEnemy: Bool) -> Bool {
        // pawns can eat on a diagonal
        if move.isDiagonal {
            if toSquareIsEnemy {
                return true
            }
        }
        // pawns can't eat on a straight line
        else {
            if toSquareIsEnemy {
                return false
            }
        }
        
        return true
    }
    
    override func makeCopy() -> Pawn {
        let piece = Pawn(isWhite: self.isWhite)
        piece.moved = self.moved
        piece.potentialCheck = self.potentialCheck
        piece.coordinates = self.coordinates
        piece.dead = self.dead
        
        return piece
    }
    
    
}
