//
//  AuthModel.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation

class AuthModel {
    
    static let shared = AuthModel()
    
    var token: String? = UserDefaults.standard.value(forKey: "token") as? String {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    var id: String? = UserDefaults.standard.value(forKey: "id") as? String {
        didSet {
            UserDefaults.standard.set(token, forKey: "id")
        }
    }
    
    func clear() {
        token = nil
        id = nil
    }
    
    var isSignedIn: Bool {
        return token != nil
    }
    
    var header: [String: String] {
        return ["Authorization": "Token \(token!)"]
    }
    
}
