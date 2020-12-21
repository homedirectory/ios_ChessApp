//
//  BoardView.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    private var board: Board?
    private var squareViews: [[SquareView]] = []
    private var lastHighlightedSquareView: SquareView?

    lazy var squareSide: CGFloat = {
        return self.frame.height / 8
    }()
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawSquares()
    }
    
    public func setBoard(board: Board) {
        self.board = board
    }
    
    func drawSquares() {
        guard let _ = self.board else { return }
        
        self.squareSide = self.frame.height / 8
        
        for row in self.board!.squares {
            var views: [SquareView] = []
            for square in row {
                let squareRect = CGRect(x: self.squareSide * CGFloat(square.coordinates.col), y: self.squareSide * CGFloat(square.coordinates.row), width: self.squareSide, height: self.squareSide)
                let squareView = SquareView(frame: squareRect)
                squareView.setSquare(square: square)
                self.addSubview(squareView)
                views.append(squareView)
            }
            self.squareViews.append(views)
        }
        
    }
    
    func update(withMove move: Move) {
        if move.isCastling {
            for coordinates in [move.from, move.to] + move.line {
                let squareView = self.getSquareView(fromCoordinates: coordinates)
                squareView.update()
                squareView.highlightOff()
            }
        }
        else {
            // update fromSquareView
            let fromSquareView = self.getSquareView(fromCoordinates: move.from)
            fromSquareView.update()
            fromSquareView.highlightOff()
            // update toSquareView
            self.getSquareView(fromCoordinates: move.to).update()
        }
    }
    
    
}


extension BoardView {
    
    // Call this method when a player touches an empty square or an enemy piece
    func turnOffLastHighlighted() {
        if let last = self.lastHighlightedSquareView {
            last.highlightOff()
            self.lastHighlightedSquareView = nil
        }
    }
    
    // Call this method only when a player touches on of his own pieces
    func manageHighlighting(forCoordinates coordinates: Coordinates) {
        // explicitly turn off the last highlighted square,
        // but if the same square is clicked multiple times in a row - don't turn it off, but switch its state
        let squareView = self.getSquareView(fromCoordinates: coordinates)
        
        if let last = self.lastHighlightedSquareView {
            if last != squareView {
                last.highlightOff()
            }
        }
        // switch highlight on the touched square and assign it to last highlighted
        self.lastHighlightedSquareView = squareView.switchHighlight()
    }
    
    private func getSquareView(fromCoordinates coordinates: Coordinates) -> SquareView {
        return self.squareViews[coordinates.row][coordinates.col]
    }
    
}
