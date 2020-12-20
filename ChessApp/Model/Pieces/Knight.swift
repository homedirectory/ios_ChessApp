//
//  Knight.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Knight: Piece {
    
    override init(isWhite: Bool) {
        super.init(isWhite: isWhite)
    }
        
    override func getPossibleCoordinates() -> [Coordinates] {
        return [Coordinates(row: self.row + 2, col: self.col + 1), Coordinates(row: self.row + 2, col: self.col - 1), Coordinates(row: self.row + 1, col: self.col + 2), Coordinates(row: self.row + 1, col: self.col - 2),
                Coordinates(row: self.row - 2, col: self.col + 1), Coordinates(row: self.row - 2, col: self.col - 1), Coordinates(row: self.row - 1, col: self.col + 2), Coordinates(row: self.row - 1, col: self.col - 2)]
    }
    
}
