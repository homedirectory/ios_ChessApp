//
//  King.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class King: Piece {
    
    override var name: String {
        return "king"
    }
    
    var underCheck: Bool = false
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
    
    override func getPossibleCoordinates() -> [Coordinates] {
        var coordinates: [Coordinates] = []
        coordinates.append(contentsOf: self.getCoordinatesOnDiagonals(depth: 1))
        coordinates.append(contentsOf: self.getCoordinatesOnStraightLines(depth: 1))
        return coordinates
    }
    
    override func makeCopy() -> King {
        let piece = King(isWhite: self.isWhite)
        piece.moved = self.moved
        piece.potentialCheck = self.potentialCheck
        piece.underCheck = self.underCheck
        piece.coordinates = self.coordinates
        piece.dead = self.dead
        
        return piece
    }
    
    func getTouchingSquaresCoordinates() -> [Coordinates] {
        let coordinates: [Coordinates] = [self.coordinates.addColumns(1), self.coordinates.addColumns(-1),
                                          self.coordinates.addRows(1).addColumns(1), self.coordinates.addRows(1).addColumns(-1),
                                          self.coordinates.addRows(-1).addColumns(1), self.coordinates.addRows(-1).addColumns(-1)]
        
        return coordinates.filter({
            Board.inBounds(coordinates: $0)
        })
    }
        
    
}

