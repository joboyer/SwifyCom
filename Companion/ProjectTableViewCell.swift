//
//  ProjectTableViewCell.swift
//  Companion
//
//  Created by Jordan BOYER on 1/25/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ProjectName: UILabel!
    @IBOutlet weak var Rating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    var tuple : (String?, String?)? {
        didSet {
            if let p = tuple {
                if !(p.0?.isEmpty)! && !(p.1?.isEmpty)! {
                    ProjectName.text = p.0
                    Rating.text = p.1
                }
            }
        }
    }
}
