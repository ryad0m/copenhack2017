//
//  Search Cell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personImage.layer.cornerRadius = personImage.bounds.size.width / 2.0
        personImage.layer.masksToBounds = true
        
        backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personImage.image = nil
    }
    
    func configure(user: UserModel) {
        personName.text = user.name
        Helper.shared.downloadAndSetImage(imageView: personImage, imageUrl: user.picture)
    }
    
}
