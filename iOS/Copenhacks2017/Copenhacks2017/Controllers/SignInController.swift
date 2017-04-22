//
//  SignInController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

let signInResultNotification: Notification.Name = Notification.Name(rawValue: "signInResult")

class SignInController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onResult(notification:)),
                                               name: signInResultNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Helper.createGradientOnView(view: view)
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        API.signIn()
    }
    
    func onResult(notification: Notification) {
        let (result, token, id) = notification.object as! (Bool, String?, String?)
        
        if result {
            AuthModel.shared.token = token
            AuthModel.shared.id = id
            dismiss(animated: true, completion: nil)
        }
    }
    
}
