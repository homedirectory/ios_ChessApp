//
//  Square.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


public class Square: Coordinates {
    
    var coordinates: [Int]
    
    var piece: Piece? {
        didSet {
            if let _ = piece {
                piece!.coordinates = self.coordinates
            }
        }
    }
    
    var isEmpty: Bool {
        self.piece == nil
    }
    
    init(coordinates: [Int], piece: Piece?) {
        self.piece = piece
        self.coordinates = coordinates
    }
    
    func removePiece() {
        self.piece = nil
    }
    
}
