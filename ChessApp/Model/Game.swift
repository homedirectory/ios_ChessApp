//
//  Game.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 22.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Game: Decodable, Encodable {
    
    enum CodingKeys: String, CodingKey {
        case id, player1, player2, lastMove, lastMoveIsWhite
    }
    
    var id: String
    var player1: Bool
    var player2: Bool
    var lastMove: [[Int]]
    var lastMoveIsWhite: Bool
    
    var started: Bool = false
    var ended: Bool = false
    
    init(id: String = "", player1: Bool, player2: Bool, lastMove: [[Int]] = [[0], [0]], lastMoveIsWhite: Bool = false) {
        self.id = id.isEmpty ? UUID().uuidString : id
        self.player1 = player1
        self.player2 = player2
        self.lastMove = lastMove
        self.lastMoveIsWhite = lastMoveIsWhite
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.player1 = try container.decode(Bool.self, forKey: .player1)
        self.player2 = try container.decode(Bool.self, forKey: .player2)
        self.lastMove = try container.decode([[Int]].self, forKey: .lastMove)
        self.lastMoveIsWhite = try container.decode(Bool.self, forKey: .lastMoveIsWhite)
    }
    
    func encoded() -> Dictionary<String, Any> {
        let dictionary: [String : Any] = ["id" : self.id,
                                          "player1" : self.player1,
                                          "player2" : self.player2,
                                          "lastMove" : self.lastMove,
                                          "lastMoveIsWhite" : self.lastMoveIsWhite]
        
        return dictionary
    }
    
    func lastMoveExists() -> Bool {
        return !self.lastMove.isEmpty && self.lastMove != [[0], [0]]
    }
    
}
