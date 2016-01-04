//
//  RealmDataManager.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/31/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmDataManager {
    
    var results = Results<(Course)>?()
    
    let config = Realm.Configuration(
        path: NSBundle.mainBundle().pathForResource("courseDataBase", ofType:"realm"),
        readOnly: true)
    
    mutating func configureRealmData() {
        let realm = try! Realm(configuration: config)
        
        results = realm.objects(Course)
    
    }
    
}
