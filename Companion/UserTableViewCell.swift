////
////  UserTableViewCell.swift
////  Companion
////
////  Created by Jordan BOYER on 1/19/18.
////  Copyright © 2018 Jordan BOYER. All rights reserved.
////
//
//import UIKit
//
//class UserTableViewCell: UITableViewCell {
//
//    
////    @IBOutlet weak var Name: UILabel!
////    @IBOutlet weak var lastName: UILabel!
////    @IBOutlet weak var Number: UILabel!
////    @IBOutlet weak var Email: UILabel!
////    @IBOutlet weak var UserImg: UIImageView!
//    
//    
//    var user : User? {
//        didSet {
//            if let t = user {
//                
//                print(t)
//                
//                let imageUrl:URL = URL(string: t.image)!
//                
//    
//                DispatchQueue.global(qos: .userInitiated).async {
//                    
//                    let imageData:NSData = NSData(contentsOf: imageUrl)!
//                    
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: imageData as Data)
//                        self.UserImg.image = image
//                        self.UserImg.contentMode = UIViewContentMode.scaleAspectFit
//                        // self.view.addSubview(imageView)
//                    }
//                }
//                
//                Name.text = t.name
//                lastName.text = t.lastname
//                Number.text = t.number
//                Email.text = t.email
//            }
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

