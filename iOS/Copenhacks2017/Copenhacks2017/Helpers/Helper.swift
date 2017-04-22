//
//  Helper.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import AlamofireImage

class Helper {
    
    static let shared: Helper = Helper()
    
    static let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let purpleColor = UIColor(red: 173.0/255.0, green: 107.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let blueColor = UIColor(red: 116.0/255.0, green: 188.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
    static func createGradientOnView(view: UIView, colors: [UIColor] = [purpleColor, blueColor]) {
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = colors.map{ $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.masksToBounds = true
        gradient.name = "copenhacks-gradient"
        
        let oldGradienLayerIndex = view.layer.sublayers?.index(where: { layer -> Bool in
            return layer.name == "copenhacks-gradient"
        })
        
        if oldGradienLayerIndex != nil {
            view.layer.replaceSublayer(view.layer.sublayers![oldGradienLayerIndex!], with: gradient)
        } else {
            view.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    static func setupNavBar() {
        let navAppearance = UINavigationBar.appearance()
        navAppearance.tintColor = UIColor.black
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }
    
    // -------------------------------
    
    let imageDownloader = ImageDownloader()
    let imageCache = AutoPurgingImageCache()
    
    func downloadAndSetImage(imageView: UIImageView, imageUrl: URL?) {
        func setImageAnimated(imageView: UIImageView, image: UIImage) {
            DispatchQueue.main.async {
                UIView.transition(with: imageView,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    imageView.image = image
                },
                                  completion: nil)
            }
        }
        
        guard let url = imageUrl else {
            print("Bad Image Url")
            return
        }
        
        guard let imageInCache = imageCache.image(for: URLRequest(url: url)) else {
            imageDownloader.download(URLRequest(url: url)) { response in
                if let image = response.result.value {
                    self.imageCache.add(image, for: URLRequest(url: url))
                    setImageAnimated(imageView: imageView, image: image)
                }
            }
            return
        }
        
        setImageAnimated(imageView: imageView, image: imageInCache)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension Date {
    
    var sti: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
    
}

