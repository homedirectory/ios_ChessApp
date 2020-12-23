//
//  Game.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 22.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation


class Game: Decodable, Encodable {
    
    static let DEFAULT_LAST_MOVE: [[Int]] = [[0], [0]]
    
    enum CodingKeys: String, CodingKey {
        case id, player1, player2, lastMove, lastMoveIsWhite, lastMoveIsCastling, abandoned, ended
    }
    
    var id: String
    var player1: Bool
    var player2: Bool
    var lastMove: [[Int]]
    var lastMoveIsWhite: Bool
    var lastMoveIsCastling: Bool
    var abandoned: Bool
    var ended: Bool
    
    var started: Bool = false
    
    init(id: String = "", player1: Bool, player2: Bool, lastMove: [[Int]] = Game.DEFAULT_LAST_MOVE, lastMoveIsWhite: Bool = false, abandoned: Bool = false, ended: Bool = false, lastMoveIsCastling: Bool = false) {
        self.id = id.isEmpty ? UUID().uuidString : id
        self.player1 = player1
        self.player2 = player2
        self.lastMove = lastMove
        self.lastMoveIsWhite = lastMoveIsWhite
        self.lastMoveIsCastling = lastMoveIsCastling
        self.abandoned = abandoned
        self.ended = ended
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.player1 = try container.decode(Bool.self, forKey: .player1)
        self.player2 = try container.decode(Bool.self, forKey: .player2)
        self.lastMove = try container.decode([[Int]].self, forKey: .lastMove)
        self.lastMoveIsWhite = try container.decode(Bool.self, forKey: .lastMoveIsWhite)
        self.lastMoveIsCastling = try container.decode(Bool.self, forKey: .lastMoveIsCastling)
        self.abandoned = try container.decode(Bool.self, forKey: .abandoned)
        self.ended = try container.decode(Bool.self, forKey: .ended)
    }
    
    func encoded() -> Dictionary<String, Any> {
        let dictionary: [String : Any] = ["id" : self.id,
                                          "player1" : self.player1,
                                          "player2" : self.player2,
                                          "lastMove" : self.lastMove,
                                          "lastMoveIsWhite" : self.lastMoveIsWhite,
                                          "lastMoveIsCastling" : self.lastMoveIsCastling,
                                          "abandoned" : self.abandoned,
                                          "ended" : self.ended]
        
        return dictionary
    }
    
    func getLastMove() -> [[Int]]? {
        if !self.lastMove.isEmpty && self.lastMove != Game.DEFAULT_LAST_MOVE {
            return self.lastMove
        }
        return nil
    }
    
}


extension Game {
    
    func toString() -> String {
        return """
                id: \(self.id)
                player1: \(self.player1)
                player2: \(self.player2)
                lastMove: \(self.lastMove)
                lastMoveIsWhite: \(self.lastMoveIsWhite)
                lastMoveIsCastling: \(self.lastMoveIsCastling)
                abandoned: \(self.abandoned)
                started: \(self.started)
                ended: \(self.ended)
                """
    }
    
}
