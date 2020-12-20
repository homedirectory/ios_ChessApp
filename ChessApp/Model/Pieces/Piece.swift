//
//  Piece.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


public class Piece {
    
    var name: String
    var isWhite: Bool = false
    var coordinates: Coordinates?
    var moved: Bool = false
    
    var row: Int {
        return self.coordinates!.row
    }
    
    var col: Int {
        return self.coordinates!.col
    }
    
    var imageName: String {
        self.name.lowercased() + "-" + (self.isWhite ? "white" : "black")
    }
    
    lazy var isWhiteSign: Int = {
        let sign = isWhite ? -1 : 1
        return sign
    }()
    
    init(isWhite: Bool) {
        self.isWhite = isWhite
        self.name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    final public func equalColor(_ piece: Piece) -> Bool {
        return (self.isWhite && piece.isWhite) || (!self.isWhite && !piece.isWhite)
    }
    
    func getPossibleCoordinates() -> [Coordinates] {
        return []
    }
    
    final func isPossibleMove(toCoordinates: Coordinates) -> Bool {
        // 1) check if toCoordinates fits the board size
        if !Board.moveInBounds(toCoordinates: toCoordinates) {
            return false
        }
        // 2) check if toCoordinates is a possibility
        let possibleCoordinates = self.getPossibleCoordinates()
        if !possibleCoordinates.contains(toCoordinates) {
            return false
        }
        
        return true
    }
    
}


extension Piece {
    
    func getCoordinatesOnDiagonals(depth: Int = Board.MAXROW) -> [Coordinates] {
        var coordinates: [Coordinates] = []
        // 4 booleans to be able to stop checking a particular diagonal when it exceeds the board size
        var diagonalUL: Bool = true
        var diagonalUR: Bool = true
        var diagonalLL: Bool = true
        var diagonalLR: Bool = true
        
        for i in 1...depth {
            //upper-left diagonal
            let coordinatesUL = Coordinates(row: self.row + i, col: self.col - i)
            if diagonalUL && Board.moveInBounds(toCoordinates: coordinatesUL) {
                coordinates.append(coordinatesUL)
            } else {
                diagonalUL = false
            }
            //upper-right diagonal
            let coordinatesUR = Coordinates(row: self.row + i, col: self.col + i)
            if diagonalUR && Board.moveInBounds(toCoordinates: coordinatesUR) {
                coordinates.append(coordinatesUR)
            } else {
                diagonalUR = false
            }
            //lower-left diagonal
            let coordinatesLL = Coordinates(row: self.row - i, col: self.col - i)
            if diagonalLL && Board.moveInBounds(toCoordinates: coordinatesLL) {
                coordinates.append(coordinatesLL)
            } else {
                diagonalLL = false
            }
            //lower-right diagonal
            let coordinatesLR = Coordinates(row: self.row - i, col: self.col + i)
            if diagonalLR && Board.moveInBounds(toCoordinates: coordinatesLR) {
                coordinates.append(coordinatesLR)
            } else {
                diagonalLR = false
            }
        }
        
        return coordinates
    }
    
    func getCoordinatesOnStraightLines(depth: Int = Board.MAXROW) -> [Coordinates]{
        var coordinates: [Coordinates] = []
        // 4 booleans to be able to stop checking a particular line when it exceeds the board size
        var lineL: Bool = true
        var lineR: Bool = true
        var lineU: Bool = true
        var lineD: Bool = true
        
        for i in 1...depth {
            //left line
            let coordinatesL = Coordinates(row: self.row, col: self.col - i)
            if lineL && Board.moveInBounds(toCoordinates: coordinatesL) {
                coordinates.append(coordinatesL)
            } else {
                lineL = false
            }
            //right line
            let coordinatesR = Coordinates(row: self.row, col: self.col + i)
            if lineR && Board.moveInBounds(toCoordinates: coordinatesR) {
                coordinates.append(coordinatesR)
            } else {
                lineR = false
            }
            //upper line
            let coordinatesU = Coordinates(row: self.row + i, col: self.col)
            if lineU && Board.moveInBounds(toCoordinates: coordinatesU) {
                coordinates.append(coordinatesU)
            } else {
                lineU = false
            }
            //down line
            let coordinatesD = Coordinates(row: self.row - i, col: self.col)
            if lineD && Board.moveInBounds(toCoordinates: coordinatesD) {
                coordinates.append(coordinatesD)
            } else {
                lineD = false
            }
        }
        
        return coordinates
    }
    
}
