//
//  Coordinates.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 20.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


struct Coordinates {
    
    let row: Int
    let col: Int
    
    var sum: Int {
        return self.row + self.col
    }
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    init(array: [Int]) {
        self.row = array[0]
        self.col = array[1]
    }
    
    func addRows(_ number: Int) -> Coordinates {
        return Coordinates(row: self.row + number, col: self.col)
    }
    
    func addColumns(_ number: Int) -> Coordinates {
        return Coordinates(row: self.row, col: self.col + number)
    }
    
    func toArray() -> [Int] {
        return [row, col]
    }
    
}


extension Coordinates: Equatable {
    
    static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
