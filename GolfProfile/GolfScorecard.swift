//
//  UserScorecard.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/23/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation
import Parse

class GolfScorecard : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "GolfScorecard"
    }
    
    @NSManaged var score: Int
    @NSManaged var date: NSDate
    @NSManaged var golfCourse: String
    @NSManaged var courseLocation: String
    @NSManaged var scorecardImage: PFFile
    @NSManaged var golfer: PFUser
    
}

