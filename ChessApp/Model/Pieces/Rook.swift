//
//  Rook.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Rook: Piece {
    
    override var name: String {
        return "rook"
    }
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [Coordinates] {
        return self.getCoordinatesOnStraightLines()
    }
    
   override func makeCopy() -> Rook {
        let piece = Rook(isWhite: self.isWhite)
        piece.moved = self.moved
        piece.potentialCheck = self.potentialCheck
        piece.coordinates = self.coordinates
        piece.dead = self.dead
        
        return piece
    }
}
