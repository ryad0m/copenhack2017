//
//  DateCell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 22/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    enum DateType {
        case start
        case end
        case once
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var type: DateType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        backgroundColor = UIColor.clear
    }
    
    func configure(with type: DateType) {
        
        switch type {
        case .start:
            title.text = "Start:"
            date.text = "Not Set"
        case .end:
            title.text = "End:"
            date.text = "Till Present"
        case .once:
            title.text = "Date:"
            date.text = "Not Set"
        }
        
    }
    
}
