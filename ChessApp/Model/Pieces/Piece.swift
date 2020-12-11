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
    
    func getPossibleCoordinates() -> [[Int]] {
        return [[Int]]()
    }
    
    final func isPossibleMove(toCoordinates: [Int]) -> Bool {
        // 1) check if toCoordinates fits the board size
        if !Self.moveInBounds(toCoordinates: toCoordinates) {
            return false
        }
        // 2) check if toCoordinates is a possibility
        let possibleCoordinates = self.getPossibleCoordinates()
        if !possibleCoordinates.contains(toCoordinates) {
            return false
        }
        
        return true
    }
    
    static func moveInBounds(toCoordinates: [Int]) -> Bool {
        return toCoordinates[0] <= Board.MAXROW && toCoordinates[1] <= Board.MAXROW
    }
    
    final public func equalColor(_ piece: Piece) -> Bool {
        return (self.isWhite && piece.isWhite) || (!self.isWhite && !piece.isWhite)
    }
    
    func getCoordinatesOnDiagonals(depth: Int = Board.MAXROW) -> [[Int]] {
        var coordinates: [[Int]] = []
        // 4 booleans to be able to stop checking a particular diagonal when it exceeds the board size
        var diagonalUL: Bool = true
        var diagonalUR: Bool = true
        var diagonalLL: Bool = true
        var diagonalLR: Bool = true
        
        for i in 1...depth {
            //upper-left diagonal
            let coordinatesUL = [self.row + i, self.col - i]
            if diagonalUL && Self.moveInBounds(toCoordinates: coordinatesUL) {
                coordinates.append(coordinatesUL)
            } else {
                diagonalUL = false
            }
            //upper-right diagonal
            let coordinatesUR = [self.row + i, self.col + i]
            if diagonalUR && Self.moveInBounds(toCoordinates: coordinatesUR) {
                coordinates.append(coordinatesUR)
            } else {
                diagonalUR = false
            }
            //lower-left diagonal
            let coordinatesLL = [self.row - i, self.col - i]
            if diagonalLL && Self.moveInBounds(toCoordinates: coordinatesLL) {
                coordinates.append(coordinatesLL)
            } else {
                diagonalLL = false
            }
            //lower-right diagonal
            let coordinatesLR = [self.row - i, self.col + i]
            if diagonalLR && Self.moveInBounds(toCoordinates: coordinatesLR) {
                coordinates.append(coordinatesLR)
            } else {
                diagonalLR = false
            }
        }
        
        return coordinates
    }
    
    func getCoordinatesOnStraightLines(depth: Int = Board.MAXROW) -> [[Int]]{
        var coordinates: [[Int]] = []
        // 4 booleans to be able to stop checking a particular line when it exceeds the board size
        var lineL: Bool = true
        var lineR: Bool = true
        var lineU: Bool = true
        var lineD: Bool = true
        
        for i in 1...depth {
            //left line
            let coordinatesL = [self.row, self.col - i]
            if lineL && Self.moveInBounds(toCoordinates: coordinatesL) {
                coordinates.append(coordinatesL)
            } else {
                lineL = false
            }
            //right line
            let coordinatesR = [self.row, self.col + i]
            if lineR && Self.moveInBounds(toCoordinates: coordinatesR) {
                coordinates.append(coordinatesR)
            } else {
                lineR = false
            }
            //upper line
            let coordinatesU = [self.row + i, self.col]
            if lineU && Self.moveInBounds(toCoordinates: coordinatesU) {
                coordinates.append(coordinatesU)
            } else {
                lineU = false
            }
            //down line
            let coordinatesD = [self.row - i, self.col]
            if lineD && Self.moveInBounds(toCoordinates: coordinatesD) {
                coordinates.append(coordinatesD)
            } else {
                lineD = false
            }
        }
        
        return coordinates
    }
    
}
