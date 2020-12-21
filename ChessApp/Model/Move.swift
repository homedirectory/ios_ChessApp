//
//  Move.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 20.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


struct Move {
    
    let from: Coordinates
    let to: Coordinates
    
    var valid: Bool = false
    var moveInvalidation: MoveInvalidation?
    
    var isDiagonal: Bool {
        return from.col != to.col && from.row != to.row
    }
    
    var isCastling: Bool = false
    
    var line: [Coordinates] {
        var coordinates: [Coordinates] = []
        
        let rowDiff = from.row - to.row
        let colDiff = from.col - to.col
        
        if abs(rowDiff) < 2 && abs(colDiff) < 2 {
            return []
        }
                
        var rowRange = rowDiff == 0 ? Array(repeating: from.row, count: abs(colDiff)) : Array([from.row, to.row].min()!..<[from.row, to.row].max()!)
        rowRange.removeFirst()
        if rowDiff > 0 {
            rowRange.reverse()
        }
        
        var colRange = colDiff == 0 ? Array(repeating: from.col, count: abs(rowDiff)) : Array([from.col, to.col].min()!..<[from.col, to.col].max()!)
        colRange.removeFirst()
        if colDiff > 0 {
            colRange.reverse()
        }
        
        for (row, col) in zip(rowRange, colRange) {
            coordinates.append(Coordinates(row: row, col: col))
        }
        
        return coordinates
    }
    
    mutating func setInvalid(reason: MoveInvalidation) {
        print(reason)
        self.valid = false
        self.moveInvalidation = reason
    }
    
    func reverse() -> Move {
        return Move(from: self.to, to: self.from)
    }
    
    
}


extension Move {
    
    enum MoveInvalidation {
        case impossibleMove
        case toOwnPiece
        case ownKingUnderCheck
        case outOfBounds
    }
    
}
