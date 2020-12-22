//
//  RealtimeDatabaseDelegate.swift
//  ChessApp
//
//  Created by Vlad Bilyk on 22.12.2020.
//  Copyright © 2020 Vlad Bilyk. All rights reserved.
//

import Foundation
import FirebaseDatabase


class RealtimeDatabaseDelegate {
    
    // singletone
    static let shared = RealtimeDatabaseDelegate()
    
    private let databaseRef = Database.database().reference()
        
    private init() { }
    
    func write(key: String, value: [String : Any], completion: (() -> ())? = nil) {
        self.databaseRef.child(key).setValue(value)
        
        if let _ = completion {
            completion!()
        }
    }
    
    func getAll(completion: @escaping ((NSDictionary?) -> ())) {
        self.databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let result = snapshot.value as? NSDictionary else {
                completion(nil)
                return
                }
            
            completion(result)
        }
    }
    
    func setObserver(key: String, callback: @escaping (NSDictionary?) -> ()) {
        self.databaseRef.child(key).observe(.value) { (snapshot) in
            guard let newValue = snapshot.value as? NSDictionary else {
                callback([:])
                return
            }
            
            callback(newValue)
        }
    }
    
}
