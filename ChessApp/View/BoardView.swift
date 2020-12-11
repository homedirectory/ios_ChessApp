//
//  BoardView.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

class BoardView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawSquares()
    }
    
    func drawSquares() {
        let squareSide = self.frame.height / 8
        
        for row in 0...Board.MAXROW {
            var squareColor = (row % 2 == 0) ? UIColor.white : UIColor.gray
            for col in 0...Board.MAXROW {
                let squareRect = CGRect(x: squareSide * CGFloat(col), y: squareSide * CGFloat(row), width: squareSide, height: squareSide)
                let squareRectView = UIView(frame: squareRect)
                squareRectView.backgroundColor = squareColor
                self.addSubview(squareRectView)
                
                squareColor = (squareColor == UIColor.gray) ? UIColor.white : UIColor.gray
            }
        }
    }

}
