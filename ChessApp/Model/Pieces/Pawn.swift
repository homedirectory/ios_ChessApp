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
    
    override func isValidMove(toCoordinates: [Int]) -> Bool {
        if !self.moveInBounds(toCoordinates: toCoordinates) {
            return false
        }
        
        var possiblecoordinatess = [[self.row + 1, self.col], [self.row + 1, self.col + 1], [self.row + 1, self.col - 1]]
        
        if !moved {
            possiblecoordinatess.append([self.row + 2, self.col])
        }
        
        if !possiblecoordinatess.contains(toCoordinates) {
            return false
        }
         
        return true
    }
    
//    override func moveTo(toCoordinates: [Int]) {
//        super.moveTo(toCoordinates: toCoordinates)
//        self.moved = true
//    }
    
    
}
