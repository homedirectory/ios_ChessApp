//
//  ViewController.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    
    weak var coordinator: Coordinator?
    private var selectedSquareCoordinates: Coordinates?
    private var board: Board?

    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.board = Board()
        
        self.boardView.setBoard(board: self.board!)
        self.view.bringSubviewToFront(self.boardView)
        
    }
    

}

extension ViewController {
    
    private func getSquareCoordinates(fromTouch touch: UITouch) -> Coordinates {
        let touchPos = touch.location(in: self.boardView)
        let row = Int(floor(touchPos.y / self.boardView.squareSide))
        let col = Int(floor(touchPos.x / self.boardView.squareSide))
        
        return Coordinates(row: row, col: col)
    }
    
    private func handleTouch(_ touch: UITouch) {
        guard let board = self.board, let boardView = self.boardView else { return }
        
        let touchedSquareCoordinates = self.getSquareCoordinates(fromTouch: touch)
                
        // if a piece was selected on a previous touch
        if let coordinates = self.selectedSquareCoordinates {
            
            if coordinates == touchedSquareCoordinates {
                self.boardView.manageHighlighting(forCoordinates: coordinates)
                self.selectedSquareCoordinates = nil
                return
            }
            
            // create move instance
            var move = Move(from: coordinates, to: touchedSquareCoordinates)
            // validate move
            board.validateMove(&move)
            
            // if move is valid
            if move.valid {
                // Model: make move
                board.makeMove(move)
                // UI: update boardView
                boardView.update(withMove: move)
                // after a move was made there is no selected square
                self.selectedSquareCoordinates = nil
                // TODO: change side to move
            }
            
            // if move is not valid
            else {
                print("move is not valid: \(move)")
                // 1) touched square is empty or contains a piece of different color from the selected one
                if move.moveInvalidation! == .impossibleMove || move.moveInvalidation! == .ownKingUnderCheck {
                    // UI: turn off highlighting
                    boardView.turnOffLastHighlighted()
                    self.selectedSquareCoordinates = nil
                }
                // 2) touched square contains own piece
                else if move.moveInvalidation! == .toOwnPiece {
                    // UI: manage highlighting
                    boardView.manageHighlighting(forCoordinates: move.to)
                    self.selectedSquareCoordinates = touchedSquareCoordinates
                }
            }
            
        }
            
        // if a piece was not selected on a previous touch
        else {
            let touchedSquare = board.getSquare(fromCoordinates: touchedSquareCoordinates)
            
            // 1) touched square is empty - do nothing
            if touchedSquare.isEmpty {
                return
            }
            // 2) touched square contains a piece
            else {
                self.selectedSquareCoordinates = touchedSquareCoordinates
                boardView.manageHighlighting(forCoordinates: touchedSquareCoordinates)
                // a) enemy piece - do nothing
                
                // b) own piece - select it and highlight
            }
        }
        
    }
    
}



extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // if the board was touched
        if boardView.subviews.contains(touch.view!) {
            self.handleTouch(touch)
        }
    }
    
}

