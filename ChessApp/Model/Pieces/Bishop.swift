//
//  Bishop.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Bishop: Piece {
    
    override var name: String {
        return "bishop"
    }
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [Coordinates] {
        return self.getCoordinatesOnDiagonals()
    }
    
    override func makeCopy() -> Bishop {
        let piece = Bishop(isWhite: self.isWhite)
        piece.moved = self.moved
        piece.potentialCheck = self.potentialCheck
        piece.coordinates = self.coordinates
        piece.dead = self.dead
        
        return piece
    }
    
}

