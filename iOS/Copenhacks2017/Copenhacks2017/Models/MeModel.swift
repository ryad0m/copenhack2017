//
//  MeModel.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MeModel {
    
    var name: String
    var fbId: String
    var picture: URL?
    var scores: [ScoreModel] = []
    var danger: ScoreModel.DangerLevel
    
    init(with json: JSON) {
        
        fbId = json["fbid"].stringValue
        name = json["name"].stringValue
        picture = URL(string: json["picture"].stringValue)
        danger = ScoreModel.DangerLevel(rawValue: json["color"].intValue)!
        
        for score in json["scores"].arrayValue {
            scores.append(ScoreModel(json: score))
        }
        
    }
    
}

struct ScoreModel {
    
    enum DangerLevel: Int {
        case low = 0
        case mid = 1
        case high = 2
        
        var color: UIColor {
            switch self {
            case .low: return UIColor(hex: "A3CE41")
            case .mid: return UIColor(hex: "EDE14D")
            case .high: return UIColor(hex: "EF2020")
            }
        }
        
    }
    
    var infection: InfectionModel
    var score: Float
    var danger: DangerLevel
    
    init(json: JSON) {
        infection = InfectionModel(with: json["disease"])
        score = json["score"].floatValue
        danger = DangerLevel(rawValue: json["color"].intValue)!
    }
    
}
