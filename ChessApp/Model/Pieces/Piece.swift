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
    private var isWhiteSign: Int {
        let sign = isWhite ? 1 : -1
        return sign
    }
    
    init(isWhite: Bool) {
        self.isWhite = isWhite
        self.name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
//    open func moveTo(toCoordinates: [Int]) {
//        self.coordinates = toCoordinates
//    }
    
    final func moveInBounds(toCoordinates: [Int]) -> Bool {
        return toCoordinates[0] <= Board.MAXROW && toCoordinates[1] <= Board.MAXROW
    }
    
    open func isValidMove(toCoordinates: [Int]) -> Bool {
        return false
    }
    
}
