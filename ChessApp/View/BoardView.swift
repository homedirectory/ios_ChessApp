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

    lazy var squareSide: CGFloat = {
        return self.frame.height / 8
    }()
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawSquares()
    }
    
    func drawSquares() {
        guard let _ = self.board else { return }
        
        self.squareSide = self.frame.height / 8
        
        for row in self.board!.squares {
            var views: [SquareView] = []
            for square in row {
                let squareRect = CGRect(x: self.squareSide * CGFloat(square.col), y: self.squareSide * CGFloat(square.row), width: self.squareSide, height: self.squareSide)
                let squareView = SquareView(frame: squareRect)
                squareView.setSquare(square: square)
                self.addSubview(squareView)
                views.append(squareView)
            }
            self.squareViews.append(views)
        }
        
    }
    
    public func setBoard(board: Board) {
        self.board = board
    }

}
