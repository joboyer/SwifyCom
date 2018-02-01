//
//  User.swift
//  Companion
//
//  Created by Jordan BOYER on 1/19/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import Foundation

struct User {
    
    let name : String
    let lastname : String
    let email : String
    let number : String
    let image : String
    
    init(name:String, ln:String, mail:String, number:String, img:String) {
        self.name = name
        self.lastname = ln
        self.email = mail
        self.number = number
        self.image = img
    }
}

