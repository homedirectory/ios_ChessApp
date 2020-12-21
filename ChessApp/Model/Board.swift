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
    
    var whitePieces : [Piece] {
        return self.squares.flatMap({ $0 }).filter({ !$0.isEmpty && $0.piece!.isWhite }).map({ $0.piece! })
    }
    
    var blackPieces : [Piece] {
        return self.squares.flatMap({ $0 }).filter({ !$0.isEmpty && !$0.piece!.isWhite }).map({ $0.piece! })
    }
    
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
    
    func makeMove(_ move: Move, isReverse: Bool = false) {
        if isReverse {
            print("making a reverse move")
        }
        var moveToMake = move
        if isReverse {
            moveToMake = move.reverse()
        }
        
        if !isReverse && self.isCastling(move) {
            self.castle(move)
            return
        }
        
        // update from square and to square
        let fromSquare = self.getSquare(fromCoordinates: moveToMake.from)
        let toSquare = self.getSquare(fromCoordinates: moveToMake.to)
        toSquare.removePiece()
        toSquare.piece = fromSquare.piece
        fromSquare.removePiece()
        toSquare.piece!.moved = !isReverse
        // update potentialCheck for a moving piece
        self.updatePotentialCheck(forPiece: toSquare.piece!)
                
        // when king moved - update potentialCheck for all pieces
        if toSquare.piece! is King {
            self.updatePotentialCheck()
        }
        // check all pieces with potentialCheck == true if they are actually checking the enemy King
        self.updateActualCheck()
        
        if !isReverse {
            print("move was made, white king under check: \(self.whiteKing!.underCheck), black king under check: \(self.blackKing!.underCheck)")
        }
    }
    
    func validateMove(_ move: inout Move) {
        print("--------- validating move from: \(move.from) to: \(move.to)")
        
        let fromSquare = self.getSquare(fromCoordinates: move.from)
        let toSquare = self.getSquare(fromCoordinates: move.to)
                
        guard let fromPiece = fromSquare.piece else {
            print("fromSquare is empty")
            return
        }
        
        print("moving piece: \(fromPiece.name)")
        
        // 1) Check the toSquare
            // contains a piece of the same color: move invalid and return
            // TODO: Castling
        if !toSquare.isEmpty {
            if toSquare.piece!.equalColor(fromPiece) {
                print("castling: ", self.isCastling(move))
                if !self.isCastling(move) {
                    move.setInvalid(reason: .toOwnPiece)
                    return
                }
                else {
                    self.validateCastling(&move)
                    return
                }
            }
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
            if self.isIllegalPass(move) {
                move.setInvalid(reason: .impossibleMove)
                return
            }
        }
        
        // Check if after making this move the king is under check
        self.makeMove(move)
        print("made a move to test if king is under check")
        if isKingUnderCheck(isWhite: fromPiece.isWhite) {
            print("after this move king is under check, invalid move, reversing")
            move.setInvalid(reason: .ownKingUnderCheck)
            self.makeMove(move, isReverse: true)
            return
        }
        else {
            print("after this move king is not under check, reversing")
            self.makeMove(move, isReverse: true)
        }
        
        move.valid = true
        
    }
    
    func isIllegalPass(_ move: Move) -> Bool {
        for coordinates in move.line {
            if !self.getSquare(fromCoordinates: coordinates).isEmpty {
                return true
            }
        }
        return false
    }
    
    func updatePotentialCheck(forPiece piece: Piece) {
        let enemyKing = piece.isWhite ? self.blackKing! : self.whiteKing!
        if piece.isPossibleMove(toCoordinates: enemyKing.coordinates) {
            print("this piece [\(piece.name)] can attack \(enemyKing.isWhite ? "white" : "black") king")
            piece.potentialCheck = true
            print("potential check")
        }
        else {
            piece.potentialCheck = false
        }
    }
    
    func updatePotentialCheck() {
        let allPieces = self.whitePieces + self.blackPieces
        for piece in allPieces {
            self.updatePotentialCheck(forPiece: piece)
        }
    }
    
    func updateActualCheck() {
//        let pieces = (attackerIsWhite ? self.whitePieces : self.blackPieces).filter({ $0.potentialCheck })
//        let enemyKing = attackerIsWhite ? self.blackKing! : self.whiteKing!
        self.blackKing!.underCheck = false
        self.whiteKing!.underCheck = false
        
        let allPieces = [self.whitePieces.filter({ $0.potentialCheck }), self.blackPieces.filter({ $0.potentialCheck })]
        let kings = [self.blackKing!, self.whiteKing!]
        
        for (pieces, king) in zip(allPieces, kings) {
            for piece in pieces {
                let attackingMove = Move(from: piece.coordinates, to: king.coordinates)
                if !self.isIllegalPass(attackingMove) {
                    king.underCheck = true
                    print("CHECK")
                }
            }
        }
    }
    
    func isCastling(_ move: Move) -> Bool {
        guard let fromPiece = self.getSquare(fromCoordinates: move.from).piece,
            let toPiece = self.getSquare(fromCoordinates: move.to).piece else {
            return false
        }
        
        if fromPiece is King && toPiece is Rook && fromPiece.equalColor(toPiece) && !isIllegalPass(move) && !fromPiece.moved && !toPiece.moved {
            return true
        }
        
        return false
    }
    
    func castle(_ move: Move, isReverse: Bool = false) {
        let kingColDiffSign = (move.to.col - move.from.col) > 0 ? 1 : -1
        
        let newKingPos = move.from.addColumns(2 * kingColDiffSign)
        let newRookPos = newKingPos.addColumns(-1 * kingColDiffSign)
        
        var king: King? = nil
        var rook: Rook? = nil
                
        if isReverse {
            king = self.getSquare(fromCoordinates: newKingPos).piece! as! King
            rook = self.getSquare(fromCoordinates: newRookPos).piece! as! Rook
            
            self.getSquare(fromCoordinates: newKingPos).removePiece()
            self.getSquare(fromCoordinates: newRookPos).removePiece()
            
            self.getSquare(fromCoordinates: move.from).piece = king
            self.getSquare(fromCoordinates: move.to).piece = rook
        }
        else {
            let kingSquare = self.getSquare(fromCoordinates: move.from)
            let rookSquare = self.getSquare(fromCoordinates: move.to)
            
            king = kingSquare.piece! as! King
            rook = rookSquare.piece! as! Rook
            
            self.getSquare(fromCoordinates: newKingPos).piece = king
            self.getSquare(fromCoordinates: newRookPos).piece = rook
            
            kingSquare.removePiece()
            rookSquare.removePiece()
        }
        
        // update potentialCheck for a moving piece
        self.updatePotentialCheck(forPiece: rook!)
                
        // when king moved (castling means king always moves) - update potentialCheck for all pieces
        self.updatePotentialCheck()
        // check all pieces with potentialCheck == true if they are actually checking the enemy King
        self.updateActualCheck()
        
        if !isReverse {
            print("move was made, white king under check: \(self.whiteKing!.underCheck), black king under check: \(self.blackKing!.underCheck)")
        }
        
    }
    
    func validateCastling(_ move: inout Move) {
        let king = self.getSquare(fromCoordinates: move.from).piece as! King
        
        self.castle(move)
        print("made a move to test if king is under check")
        if king.underCheck {
            print("after this move king is under check, invalid move, reversing")
            move.setInvalid(reason: .ownKingUnderCheck)
            self.castle(move, isReverse: true)
            return
        }
        else {
            print("after this move king is not under check, reversing")
            self.castle(move, isReverse: true)
        }
        
        move.valid = true
        move.isCastling = true
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
