//
//  MainMeCell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class MainMeCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var dangerLevelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picture.layer.cornerRadius = picture.bounds.size.width / 2.0
        picture.layer.masksToBounds = true
        
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        dangerLevelView.layer.cornerRadius = dangerLevelView.bounds.size.width / 2.0
        dangerLevelView.layer.masksToBounds = true
        
        start()
    }
    
    func start() {
        activity.startAnimating()
        dangerLevelView.isHidden = true
    }
    
    func stop() {
        activity.stopAnimating()
        dangerLevelView.isHidden = false
    }
    
    func configure(with me: MeModel) {
        name.text = me.name
        Helper.shared.downloadAndSetImage(imageView: picture, imageUrl: me.picture)
        
        dangerLevelView.backgroundColor = me.danger.color
        
        stop()
    }
    
}
