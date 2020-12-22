//
//  MenuViewController.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 22.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation
import UIKit


class MenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: Coordinator?
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        
//        var result: Game? = nil
//
//        RealtimeDatabaseDelegate.shared.getFirstUnjoinedGame(completion: { res in
//            result = res
//            print(result?.id)
//            print(type(of: result))
//        })
        
        
    }
    
    
    @IBAction func createButtonAction(_ sender: Any) {
        GameManager.shared.createGame(completion: {
            self.coordinator!.pushBoardViewController(playerIsWhite: true)
        })
        
    }
    
    @IBAction func joinButtonAction(_ sender: Any) {
        GameManager.shared.joinGame(completion: {
            self.coordinator!.pushBoardViewController(playerIsWhite: false)
        })

    }
    
}
