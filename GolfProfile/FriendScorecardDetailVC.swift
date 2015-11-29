//
//  ScorecardPhotoViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class FriendScorecardDetailVC: UIViewController {

    @IBOutlet weak var friendScorecardScrollView: UIScrollView!
    @IBOutlet weak var scorecardImageView: UIImageView!
    @IBOutlet weak var friendScorecardGCLabel: UILabel!
    @IBOutlet weak var friendScorecardDateLabel: UILabel!
    @IBOutlet weak var friendScorecardScoreLabel: UILabel!
    
    var scorecard = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendDetailedScorecardInfo()
        
        self.friendScorecardScrollView.minimumZoomScale = 1.0
        self.friendScorecardScrollView.maximumZoomScale = 6.0
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.scorecardImageView
        
    }
    
    func loadFriendDetailedScorecardInfo() {
        if let golfDate = scorecard?.objectForKey("date") as? NSDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            friendScorecardDateLabel.text = stringDate
        }
        
        if let score = scorecard?.objectForKey("score") as? Int {
            let scoreToString = "\(score)"
            friendScorecardScoreLabel.text = scoreToString
        }
        
        friendScorecardGCLabel.text = scorecard?.objectForKey("golfCourse") as? String
        
        let pfImage = scorecard!.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result != nil {
                
                self.scorecardImageView.image = UIImage(data: result!)
                
            }
        })
    
    }
    
}
