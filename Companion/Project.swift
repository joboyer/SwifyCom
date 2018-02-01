//
//  Project.swift
//  Companion
//
//  Created by Jordan BOYER on 1/25/18.
//  Copyright © 2018 Jordan BOYER. All rights reserved.
//

import Foundation

struct Project {
    
    let name : String
    let rating : String
    
    init(na: String, rat: Int) {
        self.name = na
        self.rating = String(rat)
    }
}
