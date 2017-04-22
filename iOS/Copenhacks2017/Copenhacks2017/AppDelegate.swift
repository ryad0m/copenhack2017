//
//  AppDelegate.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Helper.setupNavBar()
        UINavigationBar.appearance().isTranslucent = false
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.scheme == "copenhacks2017" {
            let (result, token, id) = OpenUrlParser.parse(query: url.query!)
            NotificationCenter.default.post(name: signInResultNotification, object: (result, token, id))
        }
        return true
    }
}

