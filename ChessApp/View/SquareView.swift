//
//  SquareView.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import UIKit

class SquareView: UIView {

    // MARK: - Properties
    
    private var square: Square?
    private var imageView: UIImageView?
    private var initialBackgroundColor: UIColor?
    private var highlighted: Bool = false
    
    // MARK: - Methods
    
    public func highlight() {
        if !self.hasImage() {
            return
        }
        if self.highlighted {
            self.backgroundColor = self.initialBackgroundColor!
        }
        else {
            self.backgroundColor = UIColor.lightGray
        }
        self.highlighted = !self.highlighted
    }
    
    // MARK: - Getters and Setters
    
    func setSquare(square: Square) {
        self.square = square
        self.initialBackgroundColor = (square.coordinates.reduce(0, +) % 2 == 0) ? UIColor.white : UIColor.gray
        self.backgroundColor = self.initialBackgroundColor!
        
        if !self.square!.isEmpty {
            self.setImage(named: self.square!.piece!.imageName)
        }
    }
    
    private func setImage(named imageName: String) {
        let image = UIImage(named: imageName)
        self.imageView = UIImageView(image: image!)
        self.imageView!.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.frame.width, height: self.frame.height)
        self.addSubview(self.imageView!)
        self.bringSubviewToFront(self.imageView!)
    }
    
    private func hasImage() -> Bool {
        return self.imageView != nil
    }
    
}
