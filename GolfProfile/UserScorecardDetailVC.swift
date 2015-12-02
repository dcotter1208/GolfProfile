//
//  UserGolfScorecardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserScorecardDetailVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    @IBOutlet weak var scorecardScoreLabel: UILabel!
    @IBOutlet weak var scorecardDateLabel: UILabel!
    @IBOutlet weak var userScorecardImageView: PFImageView!
    @IBOutlet weak var userScorecardScrollView: UIScrollView!
    
    var userScorecard = GolfScorecard?()
        
    override func viewDidLoad() {
    super.viewDidLoad()
        
    displayUserDetailedScorecardInfo()
    
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
    
    func displayUserDetailedScorecardInfo() {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        scorecardDateLabel.text = dateFormatter.stringFromDate(userScorecard!.date)
        
        scorecardScoreLabel.text = "\(userScorecard!.score)"
        golfCourseNameLabel.text = userScorecard?.golfCourse
        userScorecardImageView.file = userScorecard?.scorecardImage
        userScorecardImageView.loadInBackground()


    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
}
