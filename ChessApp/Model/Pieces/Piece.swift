//
//  Piece.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


public class Piece: Coordinates {
    
    var name: String
    var isWhite: Bool = false
    var coordinates: [Int] = []
    lazy var isWhiteSign: Int = {
        let sign = isWhite ? 1 : -1
        return sign
    }()
    
    init(isWhite: Bool) {
        self.isWhite = isWhite
        self.name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    func getPossibleCoordinates() -> [[Int]] {
        return [[Int]]()
    }
    
    final func isPossibleMove(toCoordinates: [Int]) -> Bool {
        // 1) check if toCoordinates fits the board size
        if !self.moveInBounds(toCoordinates: toCoordinates) {
            return false
        }
        // 2) check if toCoordinates is a possibility
        let possibleCoordinates = self.getPossibleCoordinates()
        if !possibleCoordinates.contains(toCoordinates) {
            return false
        }
        
        return true
    }
    
    final func moveInBounds(toCoordinates: [Int]) -> Bool {
        return toCoordinates[0] <= Board.MAXROW && toCoordinates[1] <= Board.MAXROW
    }
    
    final public func equalColor(_ piece: Piece) -> Bool {
        return (self.isWhite && piece.isWhite) || (!self.isWhite && !piece.isWhite)
    }
    
}
