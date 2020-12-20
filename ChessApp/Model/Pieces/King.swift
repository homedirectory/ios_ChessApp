//
//  King.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class King: Piece {
    
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
    
    func getTouchingSquaresCoordinates() -> [Coordinates] {
        let coordinates: [Coordinates] = [self.coordinates.addColumns(1), self.coordinates.addColumns(-1),
                                          self.coordinates.addRows(1).addColumns(1), self.coordinates.addRows(1).addColumns(-1),
                                          self.coordinates.addRows(-1).addColumns(1), self.coordinates.addRows(-1).addColumns(-1)]
        
        return coordinates.filter({
            Board.inBounds(coordinates: $0)
        })
    }
        
    
}
