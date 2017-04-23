//
//  WebController.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class WebController: UIViewController {
    
    var url: URL?
    var name: String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = name
        
        webView.loadRequest(URLRequest(url: url!))
    }
}
