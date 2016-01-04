//
//  GolferProfile.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/28/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation

import Parse

class GolferProfile : PFUser {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var name: String
    @NSManaged var profileImage: PFFile
    
}