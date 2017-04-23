//
//  InfectionCell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class InfectionCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    func configure(with infection: InfectionModel) {
        title.text = infection.name
        stateImage.image = infection.include ? #imageLiteral(resourceName: "positive") : #imageLiteral(resourceName: "empty")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stateImage.image = nil
    }
    
}
