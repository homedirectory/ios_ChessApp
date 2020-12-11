//
//  SquareView.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

class SquareView: UIView {

    private var square: Square?
        
    func setSquare(square: Square) {
        self.square = square
        self.backgroundColor = (square.coordinates.reduce(0, +) % 2 == 0) ? UIColor.white : UIColor.gray
    }

}
