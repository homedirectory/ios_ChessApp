//
//  Storyboarded.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 11.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation
import UIKit


protocol Storyboarded {
    static func instantiate(storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName: String) -> Self {
        let id = String(describing: self)
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: id) as! Self
    }
}
