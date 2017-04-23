//
//  InfectionMeCell.swift
//  Copenhacks2017
//
//  Created by Alexander Danilyak on 23/04/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit

class InfectionMeCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dangerLevelView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dangerLevelView.layer.cornerRadius = dangerLevelView.bounds.size.width / 2.0
        dangerLevelView.layer.masksToBounds = true
        
        backgroundColor = UIColor.clear
    }
    
    func configure(with score: ScoreModel) {
        
        title.text = score.infection.name
        dangerLevelView.backgroundColor = score.danger.color
        scoreLabel.text = "\(score.score)"
        scoreLabel.textColor = score.danger.color
        
    }
    
}
