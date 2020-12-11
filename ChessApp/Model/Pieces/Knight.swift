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
    
    override func isPossibleMove(toCoordinates: [Int]) -> Bool {
        return false
    }
    
    override func getPossibleCoordinates() -> [[Int]] {
        return [[self.row + 2, self.col + 1], [self.row + 2, self.col - 1], [self.row + 1, self.col + 2], [self.row + 1, self.col - 2],
                [self.row - 2, self.col + 1], [self.row - 2, self.col - 1], [self.row - 1, self.col + 2], [self.row - 1, self.col - 2]]
    }
    
}
