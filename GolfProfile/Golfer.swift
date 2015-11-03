//
//  Golfer.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation

class Golfer {
    var name: String
    var age: Int
    var country: String
    var gender: String
    var driver: String
    var irons: String
    
    
    init(name: String, age: Int, country: String, gender: String, driver: String, irons: String) {
        self.name = name
        self.age = age
        self.country = country
        self.gender = gender
        self.driver = driver
        self.irons = irons
    }
    
}