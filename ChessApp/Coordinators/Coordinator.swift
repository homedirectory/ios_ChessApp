//
//  Coordinator.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation
import UIKit


class Coordinator {
    
    var navController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }
    
    func start() {
        let vc = MenuViewController.instantiate(storyboardName: "Main")
        navController!.pushViewController(vc, animated: true)
        vc.coordinator = self
    }
    
    func pushBoardViewController(playerIsWhite: Bool) {
        let vc = BoardViewController.instantiate(storyboardName: "Main")
        navController!.pushViewController(vc, animated: true)
        vc.coordinator = self
        vc.playerIsWhite = playerIsWhite
    }

    
}
