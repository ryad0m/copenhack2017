//
//  UserModel.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserModel {
    
    var fbId: String
    var name: String
    var picture: URL?
    
    init(with json: JSON) {
        fbId = json["fbid"].stringValue
        name = json["name"].stringValue
        picture = URL(string: json["picture"].stringValue)
    }
    
}

func parseUsers(json: JSON) -> [UserModel] {
    var users: [UserModel] = []
    for userJson in json.arrayValue {
        users.append(UserModel(with: userJson))
    }
    return users
}
