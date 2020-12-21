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
    var coordinates: Coordinates = Coordinates(row: 100, col: 100)
    var moved: Bool = false {
        didSet {
            if oldValue == true {
                self.moved = true
            }
        }
    }
    var potentialCheck: Bool = false
    
    var row: Int {
        return self.coordinates.row
    }
    
    var col: Int {
        return self.coordinates.col
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
        if !Board.inBounds(coordinates: toCoordinates) {
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
            let coordinatesUL = self.coordinates.addRows(i).addColumns(-i)
            if diagonalUL && Board.inBounds(coordinates: coordinatesUL) {
                coordinates.append(coordinatesUL)
            } else {
                diagonalUL = false
            }
            //upper-right diagonal
            let coordinatesUR = self.coordinates.addRows(i).addColumns(i)
            if diagonalUR && Board.inBounds(coordinates: coordinatesUR) {
                coordinates.append(coordinatesUR)
            } else {
                diagonalUR = false
            }
            //lower-left diagonal
            let coordinatesLL = self.coordinates.addRows(-i).addColumns(-i)
            if diagonalLL && Board.inBounds(coordinates: coordinatesLL) {
                coordinates.append(coordinatesLL)
            } else {
                diagonalLL = false
            }
            //lower-right diagonal
            let coordinatesLR = self.coordinates.addRows(-i).addColumns(i)
            if diagonalLR && Board.inBounds(coordinates: coordinatesLR) {
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
            let coordinatesL = self.coordinates.addColumns(-i)
            if lineL && Board.inBounds(coordinates: coordinatesL) {
                coordinates.append(coordinatesL)
            } else {
                lineL = false
            }
            //right line
            let coordinatesR = self.coordinates.addColumns(i)
            if lineR && Board.inBounds(coordinates: coordinatesR) {
                coordinates.append(coordinatesR)
            } else {
                lineR = false
            }
            //upper line
            let coordinatesU = self.coordinates.addRows(i)
            if lineU && Board.inBounds(coordinates: coordinatesU) {
                coordinates.append(coordinatesU)
            } else {
                lineU = false
            }
            //down line
            let coordinatesD = self.coordinates.addRows(-i)
            if lineD && Board.inBounds(coordinates: coordinatesD) {
                coordinates.append(coordinatesD)
            } else {
                lineD = false
            }
        }
        
        return coordinates
    }
    
}
