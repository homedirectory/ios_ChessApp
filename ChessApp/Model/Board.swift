//
//  Board.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


public class Board {
    
    public static let MAXROW: Int = 7
    
    var squares: [[Square]] = []
    var whiteKing: King? = nil
    var blackKing: King? = nil
    
    init() {
        fillBoardWithEmptySquares()
        fillBoardWithPieces()
    }
    
    func getSquare(fromCoordinates coordinates: Coordinates) -> Square {
        return self.squares[coordinates.row][coordinates.col]
    }
    
    // MARK: - Setup
    
    private func fillBoardWithEmptySquares() {
        for rowIndex in 0...Board.MAXROW {
            var squaresRow = [Square]()
            
            for colIndex in 0...Board.MAXROW {
                squaresRow.append(Square(coordinates: Coordinates(row: rowIndex, col: colIndex), piece: nil))
            }
            
            self.squares.append(squaresRow)
        }
    }
    
    private func fillBoardWithPieces() {
        var isWhite = false
        
        var row = 1
        // for each colour, black are first
        for _ in 1...2 {
            
            // create pawns
            for iPawn in 1...8 {
                let col = iPawn - 1
                self.squares[row][col].piece = Pawn(isWhite: isWhite)
            }
            
            //change row
            row = isWhite ? 7 : 0
            
            //create rooks, knights and bishops
            for j in 0...1 {
                let rookCols = [0, 7]
                let knightCols = [1, 6]
                let bishopCols = [2, 5]
                self.squares[row][rookCols[j]].piece = Rook(isWhite: isWhite)
                self.squares[row][knightCols[j]].piece = Knight(isWhite: isWhite)
                self.squares[row][bishopCols[j]].piece = Bishop(isWhite: isWhite)
            }
            
            //create queen and king
            self.squares[row][3].piece = Queen(isWhite: isWhite)
            
            if isWhite {
                self.whiteKing = King(isWhite: isWhite)
                self.squares[row][4].piece = self.whiteKing
            } else {
                self.blackKing = King(isWhite: isWhite)
                self.squares[row][4].piece = self.blackKing
            }
            
            
            //change settings for white pieces
            row = 6
            isWhite = true
        }
    }
    
    // MARK: - Moving Logic
    
    func makeMove(_ move: Move) {
        if move.valid {
            let fromSquare = self.getSquare(fromCoordinates: move.from)
            let toSquare = self.getSquare(fromCoordinates: move.to)
            fromSquare.piece!.moved = true
            toSquare.removePiece()
            toSquare.piece = fromSquare.piece
            fromSquare.removePiece()
        }
    }
    
    func validateMove(_ move: inout Move) {
        print("validating move from: \(move.from) to: \(move.to)")
        
        let fromSquare = self.getSquare(fromCoordinates: move.from)
        let toSquare = self.getSquare(fromCoordinates: move.to)
                
        guard let fromPiece = fromSquare.piece else { return }
        
        // 1) Check the toSquare
            // contains a piece of the same color: return
            // contains a piece of different color: continue
        if !toSquare.isEmpty {
            if toSquare.piece!.equalColor(fromPiece) {
                move.setInvalid(reason: .toOwnPiece)
                return
            }
            // TODO: Check if this move puts the King of fromPiece.color under check
        }
        
        // 2) Check if this piece can move like that
        if !fromPiece.isPossibleMove(toCoordinates: toSquare.coordinates) {
            move.setInvalid(reason: .impossibleMove)
            return
        }
        
        // 3) Validation by special rules if any exist (example: Pawn can eat on a diagonal line)
        if fromPiece is Pawn {
            if !(fromPiece as! Pawn).isValidMoveBySpecialRules(move, toSquareIsEmpty: self.getSquare(fromCoordinates: move.to).isEmpty) {
                move.setInvalid(reason: .impossibleMove)
                return
            }
        }
        
        
        // 4) Check if by making this move, a piece passes through other pieces illegally
        if !(fromPiece is Knight) {
            // if this move is in a straight line (Rook, Queen, King and Pawn)
            print("move line")
            move.line.forEach({ print([$0.row, $0.col]) })
            for coord in move.line {
                if !self.getSquare(fromCoordinates: coord).isEmpty {
                    move.setInvalid(reason: .impossibleMove)
                    return
                }
                
            }
        }
        
        // 4) TODO: Check if the King is under check
        if isKingUnderCheck(isWhite: fromPiece.isWhite) {
            // TODO: check if this move protects the king
        }
        
        move.valid = true
        
    }
    
    func updateKingUnderCheck(isWhite: Bool) {
        let king = isWhite ? self.whiteKing! : self.blackKing!
        
        
        
         
    }
    
    
    func isKingUnderCheck(isWhite: Bool) -> Bool {
        if isWhite {
            return self.whiteKing!.underCheck
        }
        return self.blackKing!.underCheck
    }
    
    static func inBounds(coordinates: Coordinates) -> Bool {
        return coordinates.row <= Self.MAXROW && coordinates.col <= Self.MAXROW
    }
    
    
}
