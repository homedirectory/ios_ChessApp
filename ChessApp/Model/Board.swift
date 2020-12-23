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
    
    var checkMate: Bool = false
    var staleMate: Bool = false
    
    lazy var whitePieces : [Piece] = {
        return self.squares.flatMap({ $0 }).filter({ !$0.isEmpty && $0.piece!.isWhite }).map({ $0.piece! })
    }()
    
    lazy var blackPieces : [Piece] = {
        return self.squares.flatMap({ $0 }).filter({ !$0.isEmpty && !$0.piece!.isWhite }).map({ $0.piece! })
    }()
    
    var aliveWhitePieces: [Piece] {
        return self.whitePieces.filter({ !$0.dead })
    }
    
    var aliveBlackPieces: [Piece] {
        return self.blackPieces.filter({ !$0.dead })
    }
    
    init() {
    }
    
    func getSquare(fromCoordinates coordinates: Coordinates) -> Square {
        return self.squares[coordinates.row][coordinates.col]
    }
    
    // MARK: - Setup
    
    func generate() {
        self.fillBoardWithEmptySquares()
        self.fillBoardWithPieces()
    }
    
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
                self.squares[row][4].piece = self.whiteKing!
            } else {
                self.blackKing = King(isWhite: isWhite)
                self.squares[row][4].piece = self.blackKing!
            }
            
            
            //change settings for white pieces
            row = 6
            isWhite = true
        }
    }
    
    // MARK: - Moving Logic
    
    func makeMove(_ move: Move, callIsCheckMate: Bool = true) {
                
        if self.isCastling(move) {
            print("CASTLING")
            self.castle(move)
            return
        }
        
        // update from square and to square
        let fromSquare = self.getSquare(fromCoordinates: move.from)
        let toSquare = self.getSquare(fromCoordinates: move.to)
        
        toSquare.killPiece()
        toSquare.removePiece()
        toSquare.piece = fromSquare.piece
        fromSquare.removePiece()
        
        toSquare.piece!.moved = true
        
        // update potentialCheck for a moving piece
        self.updatePotentialCheck(forPiece: toSquare.piece!)
                
        // when king moved - update potentialCheck for all pieces
        if toSquare.piece! is King {
            self.updatePotentialCheck()
        }
        // check all pieces with potentialCheck == true if they are actually checking the King
        self.updateActualCheck()
        
        if callIsCheckMate {
            let value = self.noPossibleMoves(isWhite: !toSquare.piece!.isWhite)
            
            if self.isKingUnderCheck(isWhite: !toSquare.piece!.isWhite) {
                self.checkMate = value
            }
            else {
                self.staleMate = value
            }
        }
        
//        if callIsCheckMate && self.isKingUnderCheck(isWhite: !toSquare.piece!.isWhite) {
//            self.checkMate = self.isCheckMate(isWhite: !toSquare.piece!.isWhite)
//        }
        
        print("move was made, white king under check: \(self.whiteKing!.underCheck), black king under check: \(self.blackKing!.underCheck)")
    }
    
    func validateMove(_ move: inout Move, callIsCheckMate: Bool = true) {
        print("--------- validating move from: \(move.from) to: \(move.to)")
        
        if !Self.inBounds(coordinates: move.from) || !Self.inBounds(coordinates: move.to) {
            move.setInvalid(reason: .outOfBounds)
            return
        }
        
        let fromSquare = self.getSquare(fromCoordinates: move.from)
        let toSquare = self.getSquare(fromCoordinates: move.to)
                
        guard let fromPiece = fromSquare.piece else {
            print("fromSquare is empty")
            return
        }
        
        print("moving piece: \(fromPiece.toString())")
        
        // 1) Check the toSquare
            // contains a piece of the same color: move invalid and return
        if !toSquare.isEmpty {
            print("to square is not empty -> \(toSquare.piece!.toString())")
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
            if !(fromPiece as! Pawn).isValidMoveBySpecialRules(move, toSquareIsEnemy: toSquare.isEmpty ? false : !fromPiece.equalColor(toSquare.piece!)) {
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
        let boardCopy = self.makeCopy()
        boardCopy.makeMove(move, callIsCheckMate: false)
        print("Board Copy making move: \(move)")
        print("BOARD COPY WHITE KING COORDINATES: ", boardCopy.whiteKing!.coordinates)
        
        print("board copy king under check: ", boardCopy.isKingUnderCheck(isWhite: fromPiece.isWhite))
        
        if boardCopy.isKingUnderCheck(isWhite: fromPiece.isWhite) {
            print("after this move king is under check, invalid move")
            move.setInvalid(reason: .ownKingUnderCheck)
            return
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
        let enemyKing = piece.isWhite ? self.blackKing : self.whiteKing
        if piece.isPossibleMove(toCoordinates: enemyKing!.coordinates) {
            print("this piece [\(piece.toString())] can attack \(enemyKing!.toString())")
            piece.potentialCheck = true
            print("potential check")
        }
        else {
            piece.potentialCheck = false
        }
    }
    
    func updatePotentialCheck() {
        let allPieces = self.aliveWhitePieces + self.aliveBlackPieces
        for piece in allPieces {
            self.updatePotentialCheck(forPiece: piece)
        }
    }
    
    func updateActualCheck() {
        print(self.aliveWhitePieces.map({ $0.toString() }))
        print(self.aliveBlackPieces.map({ $0.toString() }))
        
        self.blackKing!.underCheck = false
        self.whiteKing!.underCheck = false
        
        let allPieces = [self.aliveWhitePieces.filter({ $0.potentialCheck }), self.aliveBlackPieces.filter({ $0.potentialCheck })]
        let kings = [self.blackKing, self.whiteKing]
        
        for (pieces, king) in zip(allPieces, kings) {
            for piece in pieces {
                let attackingMove = Move(from: piece.coordinates, to: king!.coordinates)
                print("attacking move: \(attackingMove)")
                if !self.isIllegalPass(attackingMove) {
                    king!.underCheck = true
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
    
    func castle(_ move: Move) {
        let kingColDiffSign = (move.to.col - move.from.col) > 0 ? 1 : -1
        
        let newKingPos = move.from.addColumns(2 * kingColDiffSign)
        let newRookPos = newKingPos.addColumns(-1 * kingColDiffSign)
        
        let kingSquare = self.getSquare(fromCoordinates: move.from)
        let rookSquare = self.getSquare(fromCoordinates: move.to)
        
        let king = kingSquare.piece! as! King
        let rook = rookSquare.piece! as! Rook
        
        self.getSquare(fromCoordinates: newKingPos).piece = king
        self.getSquare(fromCoordinates: newRookPos).piece = rook
        
        kingSquare.removePiece()
        rookSquare.removePiece()
        
        // update potentialCheck for a moving piece
        self.updatePotentialCheck(forPiece: rook)
                
        // when king moved (castling means king always moves) - update potentialCheck for all pieces
        self.updatePotentialCheck()
        // check all pieces with potentialCheck == true if they are actually checking the enemy King
        self.updateActualCheck()
        
    }
    
    func validateCastling(_ move: inout Move) {
        let boardCopy = self.makeCopy()
        let king = boardCopy.getSquare(fromCoordinates: move.from).piece as! King
        
        // can't castle if king is under check
        if king.underCheck {
            move.setInvalid(reason: .ownKingUnderCheck)
            return
        }
        
        boardCopy.castle(move)
        print("made a move to test if king is under check")
        if king.underCheck {
            print("after castling king is under check, invalid move")
            move.setInvalid(reason: .ownKingUnderCheck)
            return
        }
        else {
            print("after castling king is not under check")
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
    
    // only call this method when you know that king is under check
    func noPossibleMoves(isWhite: Bool) -> Bool {
        print("isCheckMate?")
        let pieces = isWhite ? self.aliveWhitePieces : self.aliveBlackPieces
        
        for piece in pieces {
            print("is checkmate validating piece: \(piece.toString())")
            let possibleMoves = piece.getPossibleCoordinates().map({
                Move(from: piece.coordinates, to: $0)
            })
            for var move in possibleMoves {
                self.validateMove(&move)
                if move.valid {
                    print("found a valid move: \(move)")
                    return false
                }
            }
        }
        
        return true
    }
    
    static func inBounds(coordinates: Coordinates) -> Bool {
        return (0...Board.MAXROW).contains(coordinates.row) && (0...Board.MAXROW).contains(coordinates.col)
    }
    
    
}


extension Board {
    
    func makeCopy() -> Board {
        let board = Board()
        
        for row in self.squares {
            var rowCopy: [Square] = []
            for square in row {
                let squareCopy = square.makeCopy()
                rowCopy.append(squareCopy)
                if !squareCopy.isEmpty && squareCopy.piece! is King {
                    if squareCopy.piece!.isWhite {
                        board.whiteKing = squareCopy.piece! as? King
                    }
                    else {
                        board.blackKing = squareCopy.piece! as? King
                    }
                }
            }
            board.squares.append(rowCopy)
        }
        
        board.checkMate = self.checkMate
        
        return board
    }
    
    func printBoard() {
        print("******************** BOARD ********************")
        for row in self.squares {
            let mapped = row.map { (square) -> String in
                if square.isEmpty {
                    return ""
                }
                else {
                    return "\(square.piece!.isWhite ? "white" : "black") \(square.piece!.name)"
                }
            }
            print(mapped)
        }
        print("******************** END ********************")
    }
    
}
