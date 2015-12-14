//
//  GolfCourse.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/10/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation
import Parse

class GolfCourse : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "PreviousCourse"
    }
    
    @NSManaged var courseName: String
    @NSManaged var city: String
    @NSManaged var state: String
    
}