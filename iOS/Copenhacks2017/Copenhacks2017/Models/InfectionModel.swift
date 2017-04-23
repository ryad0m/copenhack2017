//
//  InfectionModel.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InfectionModel {

    var id: String
    var name: String
    var include: Bool
    var url: URL?
    
    init(with json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        url = URL(string: json["url"].stringValue)
        include = false
    }
    
}

func parseInfections(json: JSON) -> [InfectionModel] {
    var infections: [InfectionModel] = []
    for infectionsJson in json.arrayValue {
        infections.append(InfectionModel(with: infectionsJson))
    }
    return infections
}
