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
    
    
    var project : Project? {
        didSet {
            if let P = project {
                print("New project !!")
                ProjectName.text = P.name
                Rating.text = P.rating
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
