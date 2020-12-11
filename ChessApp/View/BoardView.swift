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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawSquares()
    }
    
    func drawSquares() {
        guard let _ = self.board else { return }
        
        let squareSide = self.frame.height / 8
        
        for row in self.board!.squares {
            for square in row {
                let squareRect = CGRect(x: squareSide * CGFloat(square.col), y: squareSide * CGFloat(square.row), width: squareSide, height: squareSide)
                let squareView = SquareView(frame: squareRect)
                squareView.setSquare(square: square)
                self.addSubview(squareView)
            }
        }
        
    }
    
    public func setBoard(board: Board) {
        self.board = board
    }

}
