//
//  UserGolfScorecardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class UserGolfScorecardViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    @IBOutlet weak var scorecardScoreLabel: UILabel!
    @IBOutlet weak var scorecardDateLabel: UILabel!
    @IBOutlet weak var userScorecardImageView: UIImageView!
    @IBOutlet weak var userScorecardScrollView: UIScrollView!
    
    var userScorecard = PFObject?()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
    displayDetailedScorecardInfo()
    
    self.userScorecardScrollView.minimumZoomScale = 1.0
    self.userScorecardScrollView.maximumZoomScale = 6.0
    
    }

    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButton(sender: AnyObject) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
    return self.userScorecardImageView
        
    }
    
    func displayDetailedScorecardInfo() {
        //Getting the date from Parse and turning it into a String to display in label
        if let golfDate = userScorecard?.objectForKey("date") as? NSDate {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            scorecardDateLabel.text = stringDate
            
        }
        //Grabbing the score from Parse and turning it into a String to display in label
        if let score = userScorecard?.objectForKey("score") as? Int {
            
            let scoreToString = "\(score)"
            scorecardScoreLabel.text = scoreToString
            
        }
        
        golfCourseNameLabel.text = userScorecard?.objectForKey("golfCourse") as? String
        let pfImage = userScorecard!.objectForKey("scorecardImage") as? PFFile
        
        pfImage?.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result == nil {
                
                self.userScorecardImageView.image = UIImage(named: "noScorecard")
                
            } else {
                
                self.userScorecardImageView.image = UIImage(data: result!)
                
            }
        })
    }
    

}
