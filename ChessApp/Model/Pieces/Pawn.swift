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
        var coordinates = [[self.row + 1, self.col], [self.row + 1, self.col + 1], [self.row + 1, self.col - 1]]
        if !self.moved {
            coordinates.append([self.row + 2, self.col])
        }
        return coordinates
    }

    
}
