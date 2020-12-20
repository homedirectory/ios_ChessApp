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
        return [self.coordinates.addRows(2).addColumns(1), self.coordinates.addRows(2).addColumns(-1), self.coordinates.addRows(1).addColumns(2), self.coordinates.addRows(1).addColumns(-2),
                self.coordinates.addRows(-2).addColumns(1), self.coordinates.addRows(-2).addColumns(-1), self.coordinates.addRows(-1).addColumns(2), self.coordinates.addRows(-1).addColumns(-2)]
    }
    
}
