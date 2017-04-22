//
//  OpenUrlParser.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation

class OpenUrlParser {
    
    static func parse(query: String) -> (Bool, String?, String?) {
        var token: String?
        var id: String?
        
        let params: [String] = query.components(separatedBy: "&")
        for param in params {
            let keyValue: [String] = param.components(separatedBy: "=")
            switch keyValue[0] {
            case "token": token = keyValue[1]
            case "id": id = keyValue[1]
            case "error": return (false, nil, nil)
            default: continue
            }
        }
        return (true, token, id)
    }
    
}
