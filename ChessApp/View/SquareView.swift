//
//  SquareView.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

public class SquareView: UIView {

    // MARK: - Properties
    
    static let HIGHLIGHT_SQUARE_COLOR: UIColor = UIColor.lightGray
    static let WHITE_SQUARE_COLOR: UIColor = UIColor.white
    static let BLACK_SQUARE_COLOR: UIColor = UIColor.gray
    
    public var square: Square?
    private var imageView: UIImageView?
    private var initialBackgroundColor: UIColor?
    private var highlighted: Bool = false
    
    // MARK: - Setup
    
    func setSquare(square: Square) {
        self.square = square
        self.initialBackgroundColor = (square.coordinates.sum % 2 == 0) ? SquareView.WHITE_SQUARE_COLOR : SquareView.BLACK_SQUARE_COLOR
        self.backgroundColor = self.initialBackgroundColor!
        
        self.imageView = UIImageView()
        self.addSubview(self.imageView!)
        self.bringSubviewToFront(self.imageView!)
        self.imageView!.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.frame.width, height: self.frame.height)
        
        if !self.square!.isEmpty {
            self.setImage(named: self.square!.piece!.imageName)
        }
    }
    
    private func setImage(named imageName: String) {
//        let image = UIImage(named: imageName)
//        self.imageView = UIImageView(image: image!)
        self.imageView!.image = UIImage(named: imageName)
    }
        
    // MARK: - Methods
    
    func switchHighlight() -> SquareView? {
        if self.square!.isEmpty {
            return nil
        }
        if self.highlighted {
            self.backgroundColor = self.initialBackgroundColor!
        }
        else {
            self.backgroundColor = SquareView.HIGHLIGHT_SQUARE_COLOR
        }
        self.highlighted = !self.highlighted

        return self
    }
    
    func highlightOff() {
        self.backgroundColor = self.initialBackgroundColor!
        self.highlighted = false
    }
    

    
}
