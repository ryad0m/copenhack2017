//
//  MainSmallCell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class MainSmallCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var type: Test.Result?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
    }
    
    func configure(for type: Test.Result) {
        
        self.type = type
        
        switch type {
        case .negative:
            title.text = "I've took a STI test and it's negative"
            icon.image = #imageLiteral(resourceName: "negative")
        case .positive:
            title.text = "I've took a STI test and it's positive"
            icon.image = #imageLiteral(resourceName: "positive")
        case .additional:
            title.text = "Add new sexual connection"
            icon.image = #imageLiteral(resourceName: "plus")
        }
    
    }
    
}
