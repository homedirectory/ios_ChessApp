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
    
    override func getPossibleCoordinates() -> [[Int]] {
        var coordinates = [[self.row + self.isWhiteSign, self.col], [self.row + self.isWhiteSign, self.col + 1], [self.row + self.isWhiteSign, self.col - 1]]
        if !self.moved {
            coordinates.append([self.row + (2 * self.isWhiteSign), self.col])
        }
        return coordinates
    }

    
}
