//
//  GolfCourse.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/10/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation
import Parse
//class GolfCourse {
//    var name: String
//    
////    var latitude:Float = 0.00
////    var longitude:Float = 0.00
////    
////    var address:String = ""
////    
////    var coordinate:CLLocation {
////        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
////    }
//    
//    init(name: String) {
//    self.name = name
//    
//    }
//    
//
//}

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
    
}