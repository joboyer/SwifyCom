//
//  AchievementTableViewCell.swift
//  Companion
//
//  Created by Jordan BOYER on 2/9/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AchievementName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var achie : (String?) {
        didSet {
            if let p = achie {
                print(p)
                if !p.isEmpty {
                    AchievementName.text = p
                }
            }
        }
    }

}
