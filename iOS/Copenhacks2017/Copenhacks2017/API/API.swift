//
//  API.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

fileprivate let base: String = "http://hack.ryadom.me/"

class API {
    
    static func signIn() {
        let url = URL(string: base + "oauth/login/facebook/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func search(with q: String, completion: @escaping (JSON) -> ()) -> DataRequest {
        let url = URL(string: base + "api/search/")!
        
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: ["q": q],
                                 headers: AuthModel.shared.header).validate().responseJSON { response in
                                    switch response.result {
                                    case .success(let json): completion(JSON(json))
                                    case .failure(_): print(API.error(response: response))
                                    }
        }
    }
    
    static func add(with user: UserModel, dates: [Date?], condom: Bool, completion: @escaping (JSON) -> ()) {
        let url = URL(string: base + "api/connections/")!
        
        Alamofire.request(url,
                          method: .post,
                          parameters: ["picture": user.picture?.absoluteString ?? "",
                                       "start": dates[0]?.sti ?? "",
                                       "end": dates[1]?.sti ?? "",
                                       "name": user.name,
                                       "fbid": user.fbId,
                                       "condom": condom],
                          headers: AuthModel.shared.header).validate().responseJSON { response in
                            switch response.result {
                            case .success(let json): completion(JSON(json))
                            case .failure(_): print(API.error(response: response))
                            }
        }
    }
    
    static func getInfections(completion: @escaping (JSON) -> ()) {
        let url = URL(string: base + "api/diseases/")!
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          headers: AuthModel.shared.header).validate().responseJSON { response in
                            switch response.result {
                            case .success(let json): completion(JSON(json))
                            case .failure(_): print(API.error(response: response))
                            }
        }
    }
    
    static func check(test: Test, completion: @escaping (JSON) -> ()) {
        let url = URL(string: base + "api/checks/")!
        
        Alamofire.request(url,
                          method: .post,
                          parameters: ["is_clean": test.result! == .negative,
                                       "date": test.date!.sti,
                                       "diseases": test.apiParam],
                          encoding: JSONEncoding.default,
                          headers: AuthModel.shared.header).validate().responseJSON { response in
                            switch response.result {
                            case .success(let json): completion(JSON(json))
                            case .failure(_): print(API.error(response: response))
                            }
                        
        }
    }
    
    static func me(completion: @escaping (JSON) -> ()) {
        let url = URL(string: base + "api/me/")!
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          headers: AuthModel.shared.header).validate().responseJSON { response in
                            switch response.result {
                            case .success(let json): completion(JSON(json))
                            case .failure(_): print(API.error(response: response))
                            }
        }
    }
    
    static func sendPlayedIdForPush(playerId: String) {
        let url = URL(string: base + "api/playerid/")!
        
        Alamofire.request(url,
                          method: .put,
                          parameters: ["playerid": playerId],
                          headers: AuthModel.shared.header).validate().responseJSON { response in
                            switch response.result {
                            case .success(_): break
                            case .failure(_): print(API.error(response: response))
                            }
        }
    }
    
    // Error parsing ----------------------
    
    static func error(response: DataResponse<Any>) -> String {
        if(response.response == nil) {
            print(response.debugDescription)
            return "Connection Was Lost"
        }
        
        let statusCode: Int = response.response!.statusCode
        
        if(statusCode == 500) {
            print(response.debugDescription)
            return "500"
        }
        
        if(statusCode == 404) {
            print(response.debugDescription)
            return "404"
        }
        
        let jsonString = String(data: response.data!, encoding: String.Encoding.utf8)!
        let parsedError = JSON(parseJSON: jsonString)
        return parsedError.debugDescription
    }
    
}
