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
        let vc = ViewController.instantiate(storyboardName: "Main")
        navController?.pushViewController(vc, animated: true)
        vc.coordinator = self
    }

    
}
