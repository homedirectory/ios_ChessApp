//
//  Pawn.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Pawn: Piece {
    
    var moved: Bool = false
    
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

    
}
