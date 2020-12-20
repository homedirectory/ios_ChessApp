//
//  Square.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 03.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation
import UIKit

public class Square {
    
    var coordinates: Coordinates

    var piece: Piece? {
        didSet {
            if let piece = self.piece {
                piece.coordinates = self.coordinates
            }
        }
    }
    
    var isEmpty: Bool {
        self.piece == nil
    }
    
    init(coordinates: Coordinates, piece: Piece?) {
        self.piece = piece
        self.coordinates = coordinates
    }
    
    func removePiece() {
        self.piece = nil
    }
    
}
