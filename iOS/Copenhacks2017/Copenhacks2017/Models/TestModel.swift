//
//  TestModel.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

struct Test {
    
    enum Result {
        case negative
        case positive
        
        case additional
        
        func colors() -> [UIColor] {
            switch self {
            case .negative:
                return [UIColor(hex: "A3CE41"),
                        UIColor(hex: "31C740")]
                
            case .positive:
                return [UIColor(hex: "EFA44A"),
                        UIColor(hex: "EF2020")]
                
            case .additional:
                return [UIColor(hex: "AD6BFF"),
                        UIColor(hex: "74BCF7")]
            }
            
        }
        
        var heroID: String {
            switch self {
            case .negative:
                return "negative"
                
            case .positive:
                return "positive"
                
            case .additional:
                return ""
            }
        }
        
    }
    
    var result: Result?
    
    var date: Date?
    var infections: [InfectionModel] = []
    
    var apiParam: [String] {
        return infections.filter { $0.include == true }.map { $0.id }
    }
    
}
