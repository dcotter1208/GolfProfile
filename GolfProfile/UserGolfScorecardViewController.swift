//
//  UserGolfScorecardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class UserGolfScorecardViewController: UIViewController {
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    @IBOutlet weak var scorecardScoreLabel: UILabel!
    @IBOutlet weak var scorecardDateLabel: UILabel!
    @IBOutlet weak var userScorecardImageView: UIImageView!
    
    var userScorecard = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        golfCourseNameLabel.text = userScorecard?.objectForKey("GolfCourse") as? String
        scorecardScoreLabel.text = userScorecard?.objectForKey("score") as? String
        scorecardDateLabel.text = userScorecard?.objectForKey("date") as? String
        let pfImage = userScorecard!.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result != nil {
                
                self.userScorecardImageView.image = UIImage(data: result!)
                
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
